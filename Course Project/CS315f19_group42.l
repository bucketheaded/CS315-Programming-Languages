%option yylineno
digit				(0|1|2|3|4|5|6|7|8|9)
semicolon			\;
lp					\(
rp					\)
lcb					\{
rcb					\}
comment				\~\~
integer				{digit}+
anycharacter		.
letter				({uppercase}|{lowercase})
uppercase			[A-Z]
lowercase			[a-z]
functionname		{uppercase}{alphanumeric}*
alphanumeric		({letter}|{digit})
identifier			${letter}{alphanumeric}*
constname			$${letter}{alphanumeric}*
linecomment			{comment}([^\n])*
blockcomment		\/\~({anycharacter}|\n)*\~\/
binarydigit			(0|1)
url					\"(http\:\/\/{anycharacter}+|https\:\/\/{anycharacter}+)\"
inttype				int
connectiontype		connection
%%
\<\-					return ASSIGN_OP;
\n						return NL;
{inttype}				return INT_TYPE;
{connectiontype}		return CONNECTION_TYPE;
while					return WHILE;
if						return IF;
else					return ELSE;
loop					return LOOP;
and						return AND;
or						return OR;
xor						return XOR;
\+						return PLUS;
\-						return MINUS;
\*						return MULT;
\/						return DIV;
end						return END;
{lp}					return LP;
{rp}					return RP;
{lcb}					return LCB;
true					return TRUE;
false					return FALSE;
{rcb}					return RCB;
\<						return SMALLER_THAN;
\>						return GREATER_THAN;
\<\=					return SMALLER_OR_EQUAL;
\>\=					return GREATER_OR_EQUAL;
\=						return IS_EQUAL;
\/\=					return NOT_EQUAL;
\.						return DOT;
{semicolon}				return SEMICOLON;
,						return COMMA;
switch{digit}			return PRIMITIVE_SWITCHES;
\~						return NOT_OP;
return					return RETURN;
readTemperature			return READ_TEMPERATURE;
readHumidity			return READ_HUMIDITY;
readAirPressure			return READ_AIR_PRESSURE;
readAirQuality			return READ_AIR_QUALITY;
readLight				return READ_LIGHT;
readSoundLevel\<40\>	return READ_SOUND_LEVEL40;
readSoundLevel\<200\>	return READ_SOUND_LEVEL200;
readSoundLevel\<400\>	return READ_SOUND_LEVEL400;
readSoundLevel\<1000\>	return READ_SOUND_LEVEL1000;
readSoundLevel\<4000\>	return READ_SOUND_LEVEL4000;
{functionname}			return FUNCTION_NAME;
{url}	 				return URL;
{binarydigit}			return BINARY_DIGIT;
{integer}				return INTEGER;
time					return TIME;
createConnection		return CREATE_CONNECTION;
sendTo					return SEND_TO;
start					return START;
finish					return FINISH;
const					return CONST;
receiveFrom				return RECEIVE_FROM;
show					return SHOW;
take					return TAKE;
\"{anycharacter}*\"		return TEXT_OUTPUT;
{linecomment}			return LINE_COMMENT;
{blockcomment}			return BLOCK_COMMENT;
{identifier}			return IDENTIFIER;
{constname}				return CONST_NAME;
%%
int yywrap()		{return 1;}
