# ARCHIVER
This script compresses files larger than 50 MB (can be changed accordingly as per requirements) and directories within a specified base directory, moves them to an 'archive' folder, and generates a report detailing the archived items, which is then emailed to a specified address.

~Features
        ->File Archiving: Compresses files larger than 50 MB and moves them to the archive folder.
        ->Directory Archiving: Compresses entire directories and moves them to the archive folder.
        ->Report Generation: Creates a report detailing all archived files and directories along with their respective sizes.
        ->Email Notification: Sends the report via email to a specified address.
        
~Prerequisites
          Operating System: Linux or any Unix-like system with Bash.
Tools:
          gzip: For compressing files.
          tar: For compressing directories.  
          mail: For sending emails. Ensure your system is configured to send emails using the mail command.

~Process Overview
      Directory Check:
            Ensures the base directory ($BASE) exists.
            Creates an archive folder within the base directory if it does not already exist.
      Archiving Files:
            Uses the find command to locate files larger than 50 MB.
            Compresses these files and moves them to the archive folder.
            Removes the original files after archiving.
      Archiving Directories:
            Uses the find command to locate directories (excluding the archive folder).
            Compresses these directories and moves them to the archive folder.
            Removes the original directories after archiving.
      Report Generation:
            Logs details of the archived files and directories into a report file.
      Email Notification:
            Sends the report file as an attachment via email.

~Usage
      Step 1: Setup
      Ensure the script is executable:
                                        chmod +x archive_script.sh
                  
  Modify the script to set the correct BASE directory and EMAIL address.
          Configure your email settings to work with the mail command.
      Step 2: Execute
          Run the script with:
                                        ./name_of_script.sh

~Important Notes
        Data Removal: The script removes original files and directories after archiving them. Ensure that you have backups if necessary.
        Email Configuration: Make sure your system's mail command is correctly configured to send emails. If the email is not sent, you may need to troubleshoot your email setup.

~Troubleshooting
        Email Issues: If the email is not received, check your system's mail configuration and ensure that it can send emails.
        Permission Issues: Ensure that you have the necessary permissions to read, write, and execute files in the base directory.
