
<#
.Synopsis
   This script changes files in a directory to a format more suitable.
.DESCRIPTION
       Formats supported:
        From 'The Simpsons.S01E02.720.RIP' to 'The Simpsons 01x01.avi'.
        From 'ZNationS02E06.720Rip.lol.mp4' to 'ZNation S01xE06.mp4'
        From 'Luther.1x01.720p_HDTV_x264-Fo[Vrarbg].mp4' to 'Luther 1x01.mp4'
.PARAMETER Path
    The path to where the files that are to be renamed reside.
.PARAMETER LogChanges
    Creates a log file called Rename.log
.PARAMETER Logpath
   The path to where you want the log file.  If you leave this out, then the log file is written in the current directory (Not recommended)
.PARAMETER PlexFormat
    Formats the filename as per Plex naming convention: ShowName - sXXeYY - Optional_Info.ext
.PARAMETER PathToTVMedia
    Stores the path to the destination directory of the media files, and moves the renamed files to that location.
.EXAMPLE
   PS C:\> Rename-Episode -Path c:\ohtemp
   Looks for files to rename in C:\ohtemp and does not create a log file
.EXAMPLE
   PS C:\> Rename-Episode -Path c:\ohtemp -LogChanges
   Looks for files to rename in C:\ohtemp and creates a log file called Rename.log in the current directory (In this example, creates a log file in C:\"
.EXAMPLE
    PS C:\> "c:\ohtemp" | Rename-Episode -LogChanges -LogPath "c:\MyLogs"
    Looks for files to rename in c:\ohtemp and all sub directories and creates a log called Rename.log in c:\MyLogs
.EXAMPLE
   PS C:\> Rename-Episode -Path c:\ohtemp -PlexFormat
   Looks for files to rename in C:\ohtemp and renames the file to the Plex naming convention ie ShowName - sXXeYY - Optional_Info.ext
.EXAMPLE
   PS C:\> Rename-Episode -Path c:\ohtemp -LogChanges -PlexFormat -PathToTVMedia c:\Moved
   Looks for files to rename in c:\ohtemp to the plex naming convention, moves the renamed files to c:\moved and logs the results.
.LINK
  https://github.com/joer89/Media/
#>

function Rename-Episode {

    [CmdletBinding(SupportsShouldProcess=$true)]        

    Param (        
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateScript({
            if(Test-Path $_){$true}else{Throw "Invalid path given: $_"}
            })]
        [string]$Path,
        
        [Switch]$LogChanges,

        [ValidateScript({
            if(Test-Path $_){$true}else{Throw "Invalid log path given: $_"}
            })]
        [string]$LogPath = $path,

        [switch]$PlexFormat,

        [ValidateScript({
            if(Test-Path $_){$true}else{Throw "Invalid media path given: $_"}
            })]
        [string]$PathToTVMedia
    )

    Begin {
        $ErrorCount = 0

        if ($LogChanges) {
            write-output "LOG START: $(get-date)" | Out-File -FilePath  (Join-Path -Path $Path -ChildPath "\Rename.log")  -Append
        }#if
        
        #The pattern format is title.season.episode.SomethingWhichWillbeCutOff.extension
        [string]$Pattern1 = "^(?<title>.[\w]+[\s][\w]+)(.+?)(?<Season>[\d]+)(?<Episode>[E][\d]+)(?<Rubbish>.*)$"
        #The $Pattern format is titleSeasonEpisode.SomethingWhichWillbeCutOff.extension
        [string]$Pattern2 = "^(?<title>[\w]+)(?<Season>[s][\d]+)(?<Episode>[e][\d]+)(?<Rubbish>.*)$"
        #The $Pattern format is title.SeasonNumberxEpisodeNumber.SomethingWhichWillbeCutOff.extension
        [string]$Pattern3 = "^(?<title>[\w]+)(.+?)(?<Season>[\d]+)(.+?)(?<Episode>[\d]+)(?<Rubbish>.*)$"

    }#begin   
    
    Process {
        foreach ($FileName in (Get-ChildItem $Path -Exclude *.log,*.txt,*.dat,*.nfo -Recurse -Force)) {   

            #If the file in the directory is the same $Pattern as the $Pattern above.
            if ($Filename.name -match $Pattern2 -or $Filename.name-match $Pattern3 -and $filename.name -notlike "* *" ) {        
                    rename
               }
               elseif($Filename.name -match $Pattern1){
                    rename
               }
                else {        
                If ($Rename) {
                    #Displays a on screen message if a file doesn't match the $Pattern listed in $format.
                    Write-host -ForegroundColor Red " `n `t No matches for $Filename"
                    if ($logchanges) {
                        write-output "ERROR:     No match found for $Filename" | Out-File -FilePath  (Join-Path -Path $Path -ChildPath "\Rename.log")  -Append
                    }
                    $ErrorCount+=1
                }  
            }#else
        }#foreach
    }#process
    End {
        if ($LogChanges) {
            write-output "LOG END:   $(get-date)" | Out-File -FilePath  (Join-Path -Path $Path -ChildPath "\Rename.log")  -Append
            write-output "`n`n" | Out-File -FilePath  (Join-Path -Path $Path -ChildPath "\Rename.log")  -Append
        }#if  
        
        if ($ErrorCount -gt 0) {
            Write-Warning "File rename completed with $ErrorCount errors"
        } else {
            write-host -ForegroundColor Green "SUCCESS! File rename completed with no errors!"
        }          
    }#end
}#function


#Runs the function.
function rename{

 #Stores each Section of the $Pattern to keep from the file.     
                $Title = $matches.title -replace "[\._]"," "
                $Season = $matches.Season
                $Episode = $matches.Episode
                #Gets the file extension.
                $extension = $matches.Rubbish.Substring($matches.Rubbish.Length - 4, 4)            

                if ($PlexFormat) {
                    #Pattern2 is already in the format of Plex Formatting.
                    if($Filename.name -match $Pattern1 -or $Filename.name -match $Pattern2){
                        #$Pattern of the new file is 'TVEpisode SeasonNumberxEpisodeNumber'
                        $NewName = $Title + " " + $Season + "x" + $Episode + $extension
                    }
                    else{
                        #Format filename as per Plex naming standards (https://support.plex.tv/hc/en-us/articles/200220687-Naming-Series-Season-Based-TV-Shows)
                        $NewName = $Title + " - S" + $Season + "E" + $Episode + $extension
                    }                   
                }
                else{
                    #$Pattern of the new file is 'TVEpisode SeasonNumberxEpisodeNumber'
                    $NewName = $Title + " " + $Season + "x" + $Episode + $extension
                }#if

                #Writes the New naming convention and old file name to the screen.
                Write-host -ForegroundColor Green " `n `t New name is $NewName"
                Write-Host -ForegroundColor Yellow " `t Old name is $Filename"

                #Renames the file in the directory chosen by the user to the new format.
                Rename-Item -LiteralPath $Filename.FullName -NewName $NewName -Force
                $Rename=$true

                if ($logchanges) {
                    #Writes to log file.
                    write-output "OK:        $($Filename.fullname) >> $($NewName)" | Out-File -FilePath  (Join-Path -Path $Path -ChildPath "\Rename.log")  -Append
                }

                #If the file is renamed then moves the file, and if the param logchanges is enabled then also logs the changes.
                if (($Rename)){
                    if($PathToTVMedia){
                        Move-Item -LiteralPath ($Path+"\"+$NewName) $PathToTVMedia -Force
                        #Writes to screen.
                        Write-host -ForegroundColor Magenta  "`t Moved:     $($Path+"\"+$NewName) >> $($PathToTVMedia)" 
                         #Writes to the log file if the param is enabled.
                         if ($logchanges) {
                            write-output "Moved:     $($Path+"\"+$NewName) >> $($PathToTVMedia)" | Out-File -FilePath  (Join-Path -Path $Path -ChildPath "\Rename.log")  -Append
                        }#if
                    }#if
                }#if
}#function


#Testing
#Rename-Episode -Path c:\ohtemp -LogChanges -PlexFormat -PathToTVMedia c:\Moved