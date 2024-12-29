program RogsTextAdventurecCreateCOBOLSeqFile;

{$APPTYPE CONSOLE}

{$R *.res}
{
 Created 05/08/2024 By Roger Williams

 adjusts the level1.txt file in:

 C:\projects\COBOL\Projects\RogTextAdventureCOBOL

 so it is a CSV style for COBOL, that is instead of its current one line per record
 entry instead it is writen as ONE line.

          01 REC_ROOM_READ.
              05 INT_ROOMID_INT PIC 99 VALUE ZEROES.
      *    'next 4 propoerties determine which room this one leads to 0=no room!
              05 STR_NEXTROOMNORTH_INT PIC 99 VALUE ZEROES.
              05 STR_NEXTROOMSOUTH_INT PIC 99 VALUE ZEROES.
              05 STR_NEXTROOMEAST_INT PIC 99 VALUE ZEROES.
              05 STR_NEXTROOMWEST_INT PIC 99 VALUE ZEROES.
      *'used for text to describe room to player
              05 STR_DESC_INT1 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT2 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT3 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT4 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT5 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT6 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT7 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT8 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT9 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT10 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT11 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT12 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT13 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT14 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT15 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT16 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT17 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT18 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT19 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT20 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT21 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT22 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT23 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT24 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT25 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT26 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT27 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT28 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT29 PIC X(80) VALUE SPACES.
              05 STR_DESC_INT30 PIC X(80) VALUE SPACES.

   A nornmal CSV file would look like this:

   bob,scratchit,11/09/1980

   COBOL version would be:

   bobscratchit11/09/1980
}
uses
  System.SysUtils;

procedure AdjustLevelFile;
{
 Created 01/08/2024 By Roger Williams

 adjusts the level1.txt file

 pads each text line with spaces till line is 80 chars long
 writes the read record as a csv style single line
 does not pad the first 5 lines as these are numeric values

 NOTE: the COBOL text file has already been edited to have a
       maximum of 80 chars per text line so only need to pad to 80
       the first 5 lines are numeric data so add as is
       COBOL sequential files do NOT require a delimiter!
}
var
  filLevelIn  : TextFile; //old skool but easier to work with for this requirement
  filLevelOut : TextFile; //than TFileStream
  strData     : string;
  strTemp     : string;
  strOutput   : string;
  intNum1     : integer;
  intNum2     : integer;

begin
//open files for IO
  AssignFile(filLevelIn,'C:\projects\COBOL\Projects\RogTextAdventureCOBOL\level1_COBOL.txt');
  AssignFile(filLevelOut,'C:\projects\COBOL\Projects\RogTextAdventureCOBOL\level1_COBOL2.txt');

  Reset(filLevelIn);
  ReWrite(filLevelOut);

  while not eof(filLevelIn) do
  begin
   //reset values
   intNum2:=1;
   strOutput:='';

   //add the 5 numeric line values to the output string
   while intNum2 <> 6 do
   begin
     readln(filLevelIn,strData);
     //add to output string
     strOutput:=strOutput+strData;
     Inc(intNum2);
   end;

   //read the 30 description lines
   intNum2:=1;

   while intNum2 <> 31 do
   begin
      //get data
      readln(filLevelIn,strData);

       //is shorter than the required 80 char size?
       if length(strData) <= 80 then
       begin
         //write line to new file
         strData:=strData+StringOfChar(' ',80-length(strData));
         //add to output string
         strOutput:=strOutput+strData;
       end
      else
       begin
         //split line so not more than 80 chars
         //NOTE: bit clunky but works
         for intNum1 := 1 to 80 do
         begin
           if strData[intNum1] = ' ' then
             //this is the clunky bit, ideally needs exapanding to look at the length
             //of the word FOLLOWING the space and if end of it is <=80 leave...
             if intNum1 >75 then
             begin
               //split string at point
               strTemp:=strData.Substring(0,intNum1-1);
               //add to output string
               strOutput:=strOutput+strTemp;
               //get other half of string (bit thats beyond the 80 char limit)
               strTemp:=strData.Substring(intNum1,length(strData)-intNum1);
               //add to output string
               strOutput:=strOutput+strTemp;
               //exit for loop
               break;
             end;
         end;
       end;

       Inc(intNum2);
   end;

   //write data tp new file
   writeln(filLevelOut,strOutput);
 end;

  CloseFile(filLevelIn);
  CloseFile(filLevelOut);
end;

begin
  try
     //modify COBOL level text file
     AdjustLevelFile;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
