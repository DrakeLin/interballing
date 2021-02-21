import json
import pyodbc
from datetime import date

KEYFIELDNAMES = ["id", "season_id", "team_id", "team_abbreviation", "gp", "mp", "fgm", "fga", "fg_pct",
                 "fg3m", "fg3a", "fg3_pct", "ftm", "fta", "ft_pct", "oreb", "dreb", "reb", "ast", "tov",
                 "stl", "blk", "pf", "pts"]

def load_manifest(json_data: dict, conn: pyodbc.Connection) -> Exception:
    """ Use SQL to load records into the data structure
    Args:
        json_data: data in a Python dictionary
        conn: database connection object
    Returns:
        true if creation is successful, otherwise returns the exception
    """
    cursor = conn.cursor()
    fieldnamesql = "INSERT INTO IB.playerSeasonStats (id, season_id, team_id, team_abbreviation, gp, mp, fgm, fga, fg_pct, fg3m, fg3a, fg3_pct, ftm, fta, ft_pct, oreb, dreb, reb, ast, tov, stl, blk, pf, pts)"
    today = date.today()
    mydate = today.strftime("%Y-%m-%d")
    try:
        items = json_data.get("items")
        for item in items:
            valsql = fieldnamesql + " VALUES ("
            for i in range(len(KEYFIELDNAMES) - 1):
                fieldname = KEYFIELDNAMES[i]
                valsql += "'" + str(item.get(fieldname)) + "', "
            valsql += "'" + str(item.get(KEYFIELDNAMES[-1])) + "')"
            print("Inserting: "+valsql)
            cursor.execute(valsql)

        conn.commit()
    except Exception as exp:
        return exp

    return None


def validate_manifest(json_data: dict) -> tuple:
    try:
        # check if items exists
        if (json_data.get("items")) is None:
            raise Exception("No items key in JSON")
        # check if items is an array
        items = json_data.get("items")
        if (not isinstance(items, list)):
            raise Exception("items is not an array.")
        # check if all fields exist
        for item in items:
            num_good_keys = 0
            for key in item:
                if (key in KEYFIELDNAMES):
                    num_good_keys += 1
            if num_good_keys < len(KEYFIELDNAMES):
                raise Exception("Bad data in items.")
        return json_data, True, None
    except Exception as exp:
        return None, False, exp

def get_connection_info(file_name):
    """ Get connection details from config file
    Args:
        file_name: name of file on disk including path (relative or absolute)
    Returns:
        a dictionary containing connection details
    """
    
    # Initial empty dictionary to store connection details
    connections = {}

    # Open config file to get connection info
    with open(file_name) as f:
        lines = f.readlines()
        for line in lines:
            # remove all white space (space, tab, new line)
            line = ''.join(line.split())

            # get connection info
            connection_param, connection_value = line.split(":", 1)
            connections[connection_param] = connection_value
    return connections

def main():
    with open('./player_season_stats.json') as f:
        data = json.load(f)
    
    data, status, exp = validate_manifest(data)
    
    if status:
        # Retrieve connection information from configuration file
        connection_detail = get_connection_info("connection.config")
        ip = connection_detail["ip"]
        port = int(connection_detail["port"])
        namespace = connection_detail["namespace"]
        username = connection_detail["username"]
        password = connection_detail["password"]
        driver = "{InterSystems ODBC}"

        # Create connection to InterSystems IRIS
        connection_string = 'DRIVER={};SERVER={};PORT={};DATABASE={};UID={};PWD={}' \
            .format(driver, ip, port, namespace, username, password)

        connection = pyodbc.connect(connection_string)
        print("Connected to InterSystems IRIS")

        msg = load_manifest(data, connection)
        if msg:
            print(msg)
    else:
        print(exp)

if __name__ == '__main__':
    main()
