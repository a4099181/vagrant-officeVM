@rem file    : registry.cmd
@rem author  : seb! <sebi@sebi.one.pl>
@rem license : MIT

FORFILES /P c:\vagrant\provision\registry /M *.reg /S /C "cmd /c regedit /S @path"
