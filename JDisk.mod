IMPLEMENTATION MODULE JDisk;
FROM FIO IMPORT File, IOcheck, IOresult, Create, Close, WrBin,
  RdBin, Seek, Exists, Open;
FROM IO IMPORT WrLn, WrStr;
VAR ImageHandle: File (* OF TImageBuffer *);

PROCEDURE CreateDisk(ImageName: ARRAY OF CHAR);
  VAR ErrorCode: CARDINAL; Idx: INTEGER;
BEGIN
  IOcheck:=FALSE;
  ImageHandle:=Create(ImageName);
  ErrorCode:=IOresult();
  IF ErrorCode=0 THEN
	  FOR Idx:=0 TO SECTOR_SIZE-1 DO
	    ImageBuffer[Idx]:=EMPTY_BYTE;
	  END;
	END;
  Idx:=0;
  LOOP
    IF Idx>=DISK_SIZE THEN EXIT END;
    ImageBuffer[0]:=BYTE(Idx);
    WrBin(ImageHandle, ImageBuffer, SECTOR_SIZE);
    ErrorCode:=IOresult();
    IF ErrorCode#0 THEN
	    WriteDiskError(ErrorCode);
	    Close(ImageHandle);
	    EXIT;
    END;
    INC(Idx);	
  END;
  Close(ImageHandle);
  IOcheck:=TRUE;
END CreateDisk;
	
PROCEDURE ReadSector(Sector: INTEGER; ImageName: ARRAY OF CHAR);
  VAR ErrorCode: INTEGER;
BEGIN
  IF Exists(ImageName) THEN
	  IOcheck:=FALSE;
	  ImageHandle:=Open(ImageName);
	  IF IOresult()#0 THEN
	    WriteDiskError(IOresult());
	  END;
	  Seek(ImageHandle, LONGCARD(Sector*SECTOR_SIZE));
	  IF IOresult()#0 THEN
	    WriteDiskError(IOresult());
	  END;
	  ErrorCode:=RdBin(ImageHandle, ImageBuffer, SECTOR_SIZE);
	  IF IOresult()#0 THEN
	    WriteDiskError(IOresult());
	  END;
	  Close(ImageHandle);
	  IOcheck:=TRUE;
  END;
END ReadSector;

PROCEDURE WriteSector(Sector: INTEGER; ImageName: ARRAY OF CHAR);
  VAR ErrorCode: INTEGER;
BEGIN
  IF Exists(ImageName) THEN
	  IOcheck:=FALSE;
	  ImageHandle:=Open(ImageName);
	  IF IOresult()#0 THEN
	    WriteDiskError(IOresult());
	  END;
	  Seek(ImageHandle, LONGCARD(Sector*SECTOR_SIZE));
	  IF IOresult()#0 THEN
	    WriteDiskError(IOresult());
	  END;
	  WrBin(ImageHandle, ImageBuffer, SECTOR_SIZE);
	  IF IOresult()#0 THEN
	    WriteDiskError(IOresult());
	  END;
	  Close(ImageHandle);
	  IOcheck:=TRUE;
  END;
END WriteSector;

PROCEDURE WriteDiskError(IOError: INTEGER);
BEGIN
  WrLn;
  CASE IOError OF |
    2: WrStr('SYSTEM ERROR 002: File not found'); |
    3: WrStr('SYSTEM ERROR 003: Path not found'); |
    4: WrStr('SYSTEM ERROR 004: Too many opened files'); |
    5:   WrStr('SYSTEM ERROR 005: Access denied'); |
    6:   WrStr('SYSTEM ERROR 006: Invalid file descriptor'); |
    12:  WrStr('SYSTEM ERROR 012: Invalid access mode'); |
    15:  WrStr('SYSTEM ERROR 015: Invalid disk number'); |
    16:  WrStr('SYSTEM ERROR 016: Cannot delete current directory'); |
    17:  WrStr('SYSTEM ERROR 017: Cannot rename multiple volumes'); |
    100: WrStr('IO ERROR 100: Error reading from disk'); |
    101: WrStr('IO ERROR 101: Error writing to disk'); |
    102: WrStr('IO ERROR 102: File not assigned'); |
    103: WrStr('IO ERROR 103: File not open'); |
    104: WrStr('IO ERROR 104: File not open for input'); |
    105: WrStr('IO ERROR 105: File not open for output'); |
    106: WrStr('IO ERROR 106: Invalid number'); |
    150: WrStr('FATAL ERROR 150: Disk is write protected'); |
    151: WrStr('FATAL ERROR 151: Uknown device'); |
    152: WrStr('FATAL ERROR 152: Drive not ready'); |
    153: WrStr('FATAL ERROR 153: Uknown command'); |
    154: WrStr('FATAL ERROR 154: CRC check failed'); |
    155: WrStr('FATAL ERROR 155: Invalid drive specified'); |
    156: WrStr('FATAL ERROR 156: Disk error'); |
    157: WrStr('FATAL ERROR 157: Invalid media type'); |
    158: WrStr('FATAL ERROR 158: Sector not found'); |
    159: WrStr('FATAL ERROR 159: The printer is out of paper'); |
    160: WrStr('FATAL ERROR 160: Error writing to device'); |
    161: WrStr('FATAL ERROR 161: Error reading from device'); |
    162: WrStr('FATAL ERROR 162: Harware failure'); |
    ELSE WrStr('GENERAL ERROR: Undefined error');
  END;
END WriteDiskError;

END JDisk.