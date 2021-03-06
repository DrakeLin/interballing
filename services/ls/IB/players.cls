/// 
Class IB.players Extends (%Persistent, %JSON.Adaptor) [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = players ]
{

Property id As %Library.String(%JSONFIELDNAME = "id", MAXLEN = 128) [ SqlColumnNumber = 2 ];

Property fullname As %Library.String(%JSONFIELDNAME = "full_name", MAXLEN = 128) [ SqlColumnNumber = 3, SqlFieldName = full_name ];

Parameter USEEXTENTSET = 1;

/// Bitmap Extent Index auto-generated by DDL CREATE TABLE statement.  Do not edit the SqlName of this index.
Index DDLBEIndex [ Extent, SqlName = "%%DDLBEIndex", Type = bitmap ];

Storage Default
{
<Data name="playersDefaultData">
<Value name="1">
<Value>id</Value>
</Value>
<Value name="2">
<Value>fullname</Value>
</Value>
</Data>
<DataLocation>^EYMg.hUY5.1</DataLocation>
<DefaultData>playersDefaultData</DefaultData>
<ExtentLocation>^EYMg.hUY5</ExtentLocation>
<IdLocation>^EYMg.hUY5.1</IdLocation>
<Index name="DDLBEIndex">
<Location>^EYMg.hUY5.2</Location>
</Index>
<Index name="IDKEY">
<Location>^EYMg.hUY5.1</Location>
</Index>
<IndexLocation>^EYMg.hUY5.I</IndexLocation>
<StreamLocation>^EYMg.hUY5.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
