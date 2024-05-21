IMPLEMENTATION MODULE JDOS;	
FROM IO IMPORT WrStr, WrLn, RdStr, WrChar;
FROM BiosIO IMPORT KeyPressed;
FROM Window IMPORT Clear, TextColor, Color;
FROM Graph IMPORT InitVGA, TextMode;
FROM Str IMPORT Caps, ItemS, Length, Compare;
FROM JDisk IMPORT CreateDisk, ReadSector, WriteSector, ImageBuffer,
  ImageName;

PROCEDURE _TestSector; FORWARD;

PROCEDURE Init;
BEGIN
  InitVGA;
  TextMode;
  TextColor(LightGreen);
  Clear;
  ImageName:='boot.dsk';
END Init;

PROCEDURE Run;
VAR
  InputLine: ARRAY [0..255] OF CHAR;
  Command: ARRAY [0..255] OF CHAR;
  Delimiter: ARRAY [0..1] OF CHAR;
BEGIN
  Delimiter[0]:=' ';
  Delimiter[1]:='=';
  LOOP
	WrLn; WrChar('>');
	RdStr(InputLine);
    IF Length(InputLine)#0 THEN
	  Caps(InputLine);
	  ItemS(Command, InputLine, Delimiter, 0);
      IF Compare(Command, 'CREATE')=0 THEN CreateDisk(ImageName);
      ELSIF Compare(Command, "SECTOR")=0 THEN _TestSector;
	    ELSIF Compare(Command, "EXIT")=0 THEN EXIT;
	    ELSE WrLn; WrStr("?");
	  END;	
	END;
  END;
END Run;

PROCEDURE Close;
BEGIN
  TextColor(White);
  Clear;
END Close;

PROCEDURE _TestSector;
BEGIN
END _TestSector;

END JDOS.