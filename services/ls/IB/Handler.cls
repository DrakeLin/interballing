Class IB.Handler Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE = "application/json";

ClassMethod GetPlayerSeasonStats(name As %String) As %Status
{
    try {
        set sqlquery = "SELECT id FROM IB.players WHERE full_name LIKE '"
        set sqlquery = sqlquery_name
        set sqlquery = sqlquery_"'"
        set rs = ##class(%SQL.Statement).%ExecDirect(,sqlquery)
        // this will run only once :) but i don't know how the syntax works so im doing this :)
        set id = ""
        while rs.%Next()
        {
            set id = rs.%Get("id")
        }
        set sqlquery = "SELECT season_id, team_id, team_abbreviation, gp, mp, fgm, fga, fg_pct, fg3m, fg3a, fg3_pct, ftm, fta, ft_pct, oreb, dreb, reb, ast, tov, stl, blk, pf, pts"
        set sqlquery = sqlquery_" FROM IB.playerSeasonStats"
        set sqlquery = sqlquery_" WHERE id LIKE '"
        set sqlquery = sqlquery_id
        set sqlquery = sqlquery_"'"
        set rs = ##class(%SQL.Statement).%ExecDirect(,sqlquery)
        set itemsarray = []

        while rs.%Next()
        {
            do itemsarray.%Push(
                {
                    "season_id": (rs.%Get("season_id")),
                    "team_id": (rs.%Get("team_id")), 
                    "team_abbreviation": (rs.%Get("team_abbreviation")),
                    "gp": (rs.%Get("gp")),
                    "mp": (rs.%Get("mp")),
                    "fgm": (rs.%Get("fgm")),
                    "fga": (rs.%Get("fga")),
                    "fg_pct": (rs.%Get("fg_pct")),
                    "fg3m": (rs.%Get("fg3m")),
                    "fg3a": (rs.%Get("fg3a")),
                    "fg3_pct": (rs.%Get("fg3_pct")),
                    "ftm": (rs.%Get("ftm")),
                    "fta": (rs.%Get("fta")),
                    "ft_pct": (rs.%Get("ft_pct")),
                    "oreb": (rs.%Get("oreb")),
                    "dreb": (rs.%Get("dreb")),
                    "reb": (rs.%Get("reb")),
                    "ast": (rs.%Get("ast")),
                    "tov": (rs.%Get("tov")),
                    "stl": (rs.%Get("stl")),
                    "blk": (rs.%Get("blk")),
                    "pf": (rs.%Get("pf")),
                    "pts": (rs.%Get("pts"))
                }
            )
        }
        set itemsobj = {}
        set itemsobj."rowcount" = rs.%ROWCOUNT
        set itemsobj."items" = itemsarray
        write itemsobj.%ToJSON()

    } catch (oException) {
        set expobj = {}
        set expobj."exception" = oException
        write expobj.%ToJSON()
    }
    Quit $$$OK
}

ClassMethod GetJSONFromRequest(Output obj As %DynamicObject) As %Boolean
{
    set ok = 1
    try {
        set obj = ##class(%DynamicObject).%FromJSON(%request.Content)
    } catch ex {
        set ok = 0
    }
    Quit ok
}

ClassMethod ListPlayers() As %Status
{
    try {
        set sqlquery = "SELECT id, full_name FROM IB.players"
        set rs = ##class(%SQL.Statement).%ExecDirect(,sqlquery)
        set itemsarray = []

        while rs.%Next()
        {
            do itemsarray.%Push(
                {
                    "id": (rs.%Get("id")),
                    "name": (rs.%Get("full_name"))
                }
            )
        }
        set itemsobj = {}
        set itemsobj."rowcount" = rs.%ROWCOUNT
        set itemsobj."items" = itemsarray
        write itemsobj.%ToJSON()
    } catch (oException) {
        set expobj = {}
        set expobj."exception" = oException
        write expobj.%ToJSON()
    }
    Quit $$$OK
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/players" Method="GET" Call="ListPlayers" />
    <Route Url="/players/:name" Method="GET" Call="GetPlayerSeasonStats" />
</Routes>
}

}
