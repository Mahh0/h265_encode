# h265_encode
Small powershell script to automatically to automatically encode videos to h265 to save some space.

## 1. Prérequis
1. Handbrakecli
  - Download [HandbrakeCli](https://handbrake.fr/downloads.php) : select **Other** > **Command Line Version** and **select Windows x64**
  - **Unzip the folder** and **place it into a program directory** (for example I have C:\Program Files (x86)\HandBrakeCLI-1.6.0-win-x86_64) and into this folder I have the HandBrakeCLI.exe
  - Add this folder to PATH : 
      - Type PATH in Windows
      - In the window : Modify Environment variables > Env variable > and into system (or user) modify the path to add the path to the exe (ex : C:\Program Files (x86)\HandBrakeCLI-1.6.0-win-x86_64)

## 2. How to install
1. Put the PS1 script somewhere (mine is in C:\Users\mahoa)
2. Update the script with your values (yep I'm too lazy to make an env file)
	- Line 1 & 10 if folder is different
	- Line 7 & 19 & 56 if you wan't a different log location
	- Line 37 if you also wan't other files like m4v, ...
	- Maybe others that I forgot...
3. Create the scheduled task :
	- Windows > Task Scheduler
	- Create a task
	- In general :
		- Name : h265_compress
	- In triggers :
		- At session opening, select ur user
	- In actions : 
		- Start a program > The ps1 script

## 3. Infos
- Log files are located into **C:\Windows\Temp**
- Main log file : **log_h265_date.txt**
- handbrakecli commands log file : **commands_date.txt**
