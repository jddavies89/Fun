<#
  .Description
    This script changes the format of a file from say 'The Simpsons.S01E02.720.RIP' to 'The Simpsons 01x01.avi' in the directory listed by the user.
 
  .Example 1
    .\BackupMedia.ps1

  .Example 2
    Put the script in a Task Scheduler.
 
  .Notes
    Name  : BackupMedia
    Author: Joe Richards
    Date  : 23/12/2016
 
  .Link
  https://github.com/joer89/Media/
#>




#Define the veribles for copying my TV Programs.
$CopyTV = "T:\"
$PastTV = "G:\TV"

#Define the veriblees for copying my Films.
$CopyFilms = "F:\"
$PastFilms = "G:\Films\"

#List the TV files in the array.
$ListTV = Get-ChildItem -Recurse -Path $CopyTV

#List the film files in the array.
$ListFilms = Get-ChildItem -Recurse -Path $CopyFilms


#Backup TV series.
for ($j =1; $j -lt $listTV.count; $j++){

        #Creates a live progress bar of the TV files being copied.
        Write-Progress -Id 1 -Activity 'Part 1 of 2;   Copying TV files...' -Status 'Progress->' -PercentComplete ($j / $listTV.Count*100) -CurrentOperation ($ListTV[$j].FullName + "           " + $j)
    
        #Copy each file from TV directory to the backup directory. 
        Copy-Item -Path $ListTV[$j].FullName -Destination $PastTV  -Recurse -Force
        }
    }     

#Backup Films.
for ($x =1; $x -lt $listFilms.count; $x++){

        #Creates a live progress bar of the Film files being copied.
        Write-Progress -Id 2 -Activity 'Part 2 of 2;    Copying Films files...' -Status 'Progress->' -PercentComplete ($x / $listFilms.Count*100) -CurrentOperation ($ListFilms[$x].FullName + "           " + $x)
       
        #Copy each file from TV directory to the backup directory. 
        Copy-Item -Path $ListFilms[$x].FullName -Destination $PastFilms -Recurse -Force
}
