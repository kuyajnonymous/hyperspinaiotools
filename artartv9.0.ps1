# Load necessary assemblies for Windows Forms and WPF
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName WindowsFormsIntegration  # Needed for integrating WPF controls into Windows Forms



# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "RetroCade AIO Tools by JNONYMOUS"
$form.Size = New-Object System.Drawing.Size(405, 450)  # Increased height for new label section
$form.StartPosition = "CenterScreen"

# Create a text box for the game folder
$folderTextBox = New-Object System.Windows.Forms.TextBox
$folderTextBox.Location = New-Object System.Drawing.Point(10, 40)
$folderTextBox.Size = New-Object System.Drawing.Size(200, 25)
$form.Controls.Add($folderTextBox)
$folderTextBox.Visible = $false

# Create a button to browse for the game folder
$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "Browse"
$browseButton.Location = New-Object System.Drawing.Point(255, 38)
$browseButton.Size = New-Object System.Drawing.Size(75, 23)
$form.Controls.Add($browseButton)

# Create a dropdown for selected game
$selectedGameDropdown = New-Object System.Windows.Forms.ComboBox
$selectedGameDropdown.Location = New-Object System.Drawing.Point(10, 70)
$selectedGameDropdown.Size = New-Object System.Drawing.Size(200, 21)
$form.Controls.Add($selectedGameDropdown)

# Create the clickable box on the right of the TextBox and ComboBox rows
$addBox = New-Object System.Windows.Forms.Button
$addBox.Text = "ADD"
#$addBox.Location = New-Object System.Drawing.Point(340, 38)  # Right of the TextBox and Button
$addBox.Size = New-Object System.Drawing.Size(100, 30)
$form.Controls.Add($addBox)

# Create boxes for logo, wheel, and video
$logoBox = New-Object System.Windows.Forms.GroupBox
$logoBox.Text = "Logo"
$logoBox.Location = New-Object System.Drawing.Point(10, 100)
$logoBox.Size = New-Object System.Drawing.Size(145, 210)
$form.Controls.Add($logoBox)

# Adjust existing elements to move below the new GroupBox
$folderTextBox.Location = New-Object System.Drawing.Point(100, 75)
$browseButton.Location = New-Object System.Drawing.Point(10, 73)
$selectedGameDropdown.Location = New-Object System.Drawing.Point(100, 75)
$addBox.Location = New-Object System.Drawing.Point(310, 73)


# Create a new button below browseButton and folderTextBox
$reshade6Button = New-Object System.Windows.Forms.Button
$reshade6Button.Text = "ReShade6.3"
$reshade6Button.Location = New-Object System.Drawing.Point(10, 105)  # Adjust Y-coordinate to place it below
$reshade6Button.Size = New-Object System.Drawing.Size(80, 23)  # Adjust size if needed
$form.Controls.Add($reshade6Button)

# Create a new button below browseButton and folderTextBox
$reshade4Button = New-Object System.Windows.Forms.Button
$reshade4Button.Text = "ReShade4.0"
$reshade4Button.Location = New-Object System.Drawing.Point(100, 105)  # Adjust Y-coordinate to place it below
$reshade4Button.Size = New-Object System.Drawing.Size(80, 23)  # Adjust size if needed
$form.Controls.Add($reshade4Button)

# Create a new button below browseButton and folderTextBox
$StartExeButton = New-Object System.Windows.Forms.Button
$StartExeButton.Text = "Start Game"
$StartExeButton.Location = New-Object System.Drawing.Point(200, 105)  # Adjust Y-coordinate to place it below
$StartExeButton.Size = New-Object System.Drawing.Size(100, 23)  # Adjust size if needed
$form.Controls.Add($StartExeButton)

# Create global variables
$global_steamdir_path = $null
$global_steam_user_data_path = $null


# Define functionality for the ReShade4Button
$reshade4Button.Add_Click({
    $reshade4Path = "$global:hyperspinLocation\techpinoy-plugins\ReShade_Setup_4.0.0.exe"
    if (Test-Path $reshade4Path) {
        Start-Process $reshade4Path
    } else {
[System.Windows.Forms.MessageBox]::Show("Set Hyperspin Location First", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Define functionality for the ReShade6Button
$reshade6Button.Add_Click({
    $reshade6Path = "$global:hyperspinLocation\techpinoy-plugins\ReShade_Setup_6.3.3.exe"
    if (Test-Path $reshade6Path) {
        Start-Process $reshade6Path
    } else {
        [System.Windows.Forms.MessageBox]::Show("Set Hyperspin Location First", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Define functionality for the StartExeButton
$StartExeButton.Add_Click({
    if ($global:batPath) {
        if (Test-Path $global:batPath) {
            Start-Process $global:batPath
        } else {
            [System.Windows.Forms.MessageBox]::Show("Starting $global:selectedGameFolder", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("No game selected.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})



# Function to browse for Steam folder and search for shortcuts.vdf
function Browse-SteamDirectory {
    # Show a folder browser dialog to select Steam directory
    $steamDirDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $steamDirDialog.Description = "Select your Steam installation folder"
    
    if ($steamDirDialog.ShowDialog() -eq "OK") {
        # Set the selected Steam directory to $steamdir
        $global:steamdir = $steamDirDialog.SelectedPath
        Write-Host "Steam Directory has been set to $global:steamdir"
        
        # Now, search for shortcuts.vdf inside the userdata folder
        $steamUserDataFolder = Join-Path $global:steamdir "userdata"
        
        if (Test-Path $steamUserDataFolder) {
            $shortcutsFile = Get-ChildItem -Path $steamUserDataFolder -Recurse -Filter "shortcuts.vdf" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($shortcutsFile) {
                # Set the directory containing shortcuts.vdf to $vdffolder
                $global:vdffolder = $shortcutsFile.DirectoryName
                Write-Host "User Profile Selected : $global:vdffolder"
            } else {
                Write-Host "No shortcuts.vdf file found in the userdata folder. User Profile Selected"
            }
        } else {
            Write-Host "userdata folder not found in the Steam directory. User Profile Selected"
        }
    } else {
        Write-Host "Folder selection canceled."
    }
}

# Create the CheckBox for "Add to Steam"
$steam = New-Object System.Windows.Forms.CheckBox
$steam.Location = New-Object System.Drawing.Point(320, 82)  # Original position of addBox
$steam.Text = "Add to Steam"  # Set the label of the checkbox

# Adjust the location to place the checkbox under the existing location
$checkboxLocationY = $steam.Location.Y + $steam.Height + 5  # Add a small margin
$steam.Location = New-Object System.Drawing.Point($steam.Location.X, $checkboxLocationY)

# Add the checkbox to the form
$form.Controls.Add($steam)

# Event handler for checkbox click
$steam.Add_CheckedChanged({
    if ($steam.Checked) {
        # Prompt to browse for Steam directory when checked
        #Write-Host "Checkbox checked, prompting for Steam directory..."
        Browse-SteamDirectory
    }
})




$wheelBox = New-Object System.Windows.Forms.GroupBox
$wheelBox.Text = "Wheel"
$wheelBox.Location = New-Object System.Drawing.Point(160, 100)
$wheelBox.Size = New-Object System.Drawing.Size(250, 75)
$form.Controls.Add($wheelBox)

# Create the Video GroupBox (unchanged)
$videoBox = New-Object System.Windows.Forms.GroupBox
$videoBox.Text = "Video"
$videoBox.Location = New-Object System.Drawing.Point(160, 180)
$videoBox.Size = New-Object System.Drawing.Size(250, 130)
$form.Controls.Add($videoBox)

# Initial Image paths for logo and wheel
#$global:logoPath = "$global:hyperspinLocation\layouts\NXL HD\Logo.png"
#$global:wheelPath = "$global:hyperspinLocation\layouts\NXL HD\Wheel.png"
#$unknownMediaImg = "$global:hyperspinLocation\layouts\NXL HD\unknownmedia.png"  # Path for the fallback image

# Create PictureBox for the logo
$logoPictureBox = New-Object System.Windows.Forms.PictureBox
$logoPictureBox.Image = [System.Drawing.Image]::FromFile($global:logoPath)
$logoPictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
$logoPictureBox.Dock = "Fill"
$logoBox.Controls.Add($logoPictureBox)

# Create PictureBox for the wheel
$wheelPictureBox = New-Object System.Windows.Forms.PictureBox
$wheelPictureBox.Image = [System.Drawing.Image]::FromFile($global:wheelPath)
$wheelPictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
$wheelPictureBox.Dock = "Fill"
$wheelBox.Controls.Add($wheelPictureBox)

# Create PictureBox for the video
$vidfile = "$global:hyperspinLocation\layouts\NXL HD\snap.mp4"
$mediaElement = New-Object System.Windows.Controls.MediaElement
$mediaElement.Width = 250
$mediaElement.Height = 130
$mediaElement.Stretch = [System.Windows.Media.Stretch]::Fill
$mediaElement.Source = $vidfile
$wpfHost = New-Object System.Windows.Forms.Integration.ElementHost
$wpfHost.Dock = "Fill"
$wpfHost.Child = $mediaElement
$videoBox.Controls.Add($wpfHost)

# Labels for the bottom of the form (Romlist, CFG, RocketLauncher, Artworks)
# Labels for the bottom of the form (Romlist, CFG, RocketLauncher, Artworks)
$romlistLabel = New-Object System.Windows.Forms.Label
$romlistLabel.Text = "Romlist"
$romlistLabel.Location = New-Object System.Drawing.Point(10, 320)
$romlistLabel.Size = New-Object System.Drawing.Size(50, 20)
$form.Controls.Add($romlistLabel)

$cfgLabel = New-Object System.Windows.Forms.Label
$cfgLabel.Text = "CFG"
$cfgLabel.Location = New-Object System.Drawing.Point(, 320)
$cfgLabel.Size = New-Object System.Drawing.Size(30, 20)
$form.Controls.Add($cfgLabel)

$xmlLabel = New-Object System.Windows.Forms.Label
$xmlLabel.Text = "XML"
$xmlLabel.Location = New-Object System.Drawing.Point(170, 320)  # Positioned next to CFG
$xmlLabel.Size = New-Object System.Drawing.Size(30, 20)
$form.Controls.Add($xmlLabel)

$batLabel = New-Object System.Windows.Forms.Label
$batLabel.Text = "BAT"
$batLabel.Location = New-Object System.Drawing.Point(340, 320)  # Positioned next to XML
$batLabel.Size = New-Object System.Drawing.Size(30, 20)
$form.Controls.Add($batLabel)



# Add the click event to launch RocketLauncherUI.exe
$batLabel.Add_Click({
    Start-Process "$global:batPath"
})

$form.Controls.Add($batLabel)



# RocketLauncher label
$rocketLauncherLabel = New-Object System.Windows.Forms.Label
$rocketLauncherLabel.Text = "RocketLauncher"
$rocketLauncherLabel.Size = New-Object System.Drawing.Size(90, 20)

# Add the click event to launch RocketLauncherUI.exe
$rocketLauncherLabel.Add_Click({
    Start-Process "$hyperspinlocation\RocketLauncher\RocketLauncherUI\RocketLauncherUI.exe"
})

$form.Controls.Add($rocketLauncherLabel)


# Artworks label, starts as gray
$artworksLabel = New-Object System.Windows.Forms.Label
$artworksLabel.Text = "Artworks"
$artworksLabel.Location = New-Object System.Drawing.Point(560, 320)  # Positioned next to RocketLauncher
$artworksLabel.Size = New-Object System.Drawing.Size(70, 20)
$artworksLabel.ForeColor = [System.Drawing.Color]::Gray  # Default color
$form.Controls.Add($artworksLabel)



# Adjust all labels to be on the same line within a 500px width
$romlistLabel.Location = New-Object System.Drawing.Point(10, 355)
$cfgLabel.Location = New-Object System.Drawing.Point(60, 355)
$xmlLabel.Location = New-Object System.Drawing.Point(100, 355)
$batLabel.Location = New-Object System.Drawing.Point(140, 355)
$rocketLauncherLabel.Location = New-Object System.Drawing.Point(180, 355)
$artworksLabel.Location = New-Object System.Drawing.Point(280, 355)
#$EmulatorLabel.Location = New-Object System.Drawing.Point(380, 355)

# Ensure the total width of the labels fits within the form
$form.Width = 500  # Resize form if necessary to fit within 500px



# Create a GroupBox for Hyperspin settings at the top
$hyperspinGroupBox = New-Object System.Windows.Forms.GroupBox
$hyperspinGroupBox.Text = "Hyperspin Settings"
$hyperspinGroupBox.Location = New-Object System.Drawing.Point(10, 10)  # Top of the form
$hyperspinGroupBox.Size = New-Object System.Drawing.Size(400, 55)  # Adjusted width to fit form
$form.Controls.Add($hyperspinGroupBox)


# Create the Browse button inside the group box
$browseButtonTop = New-Object System.Windows.Forms.Button
$browseButtonTop.Text = "Select Hyperspin"
$browseButtonTop.Location = New-Object System.Drawing.Point(10, 20)
$browseButtonTop.Size = New-Object System.Drawing.Size(110, 23)
$hyperspinGroupBox.Controls.Add($browseButtonTop)

# Create a label to display the selected folder path inside the group box
$selectedFolderLabel = New-Object System.Windows.Forms.Label
$selectedFolderLabel.Location = New-Object System.Drawing.Point(130, 24)  # Positioned to the right of the button
$selectedFolderLabel.Size = New-Object System.Drawing.Size(100, 20)
$selectedFolderLabel.Text = "No folder selected"
$hyperspinGroupBox.Controls.Add($selectedFolderLabel)

# Create a dropdown list (ComboBox) for collections, aligned to the right of the label
$collectionsDropdown = New-Object System.Windows.Forms.ComboBox
$collectionsDropdown.Location = New-Object System.Drawing.Point(240, 20)  # Positioned to the right of the label
$collectionsDropdown.Size = New-Object System.Drawing.Size(160, 23)
$collectionsDropdown.DropDownStyle = "DropDownList"  # Read-only dropdown
$hyperspinGroupBox.Controls.Add($collectionsDropdown)




$logoBox.Location = New-Object System.Drawing.Point(10, 135)
$wheelBox.Location = New-Object System.Drawing.Point(160, 135)
$videoBox.Location = New-Object System.Drawing.Point(160, 215)




















# Declare global variables outside the event handler

# Global variables to store media paths and existence flags
#$global:hyperspinLocation = $global:hyperspinLocation
$emulator = $global:emulator
$global:logoPath = $null
$global:wheelPath = $null
$global:videoPath = $null
$global:logoExists = $false
$global:wheelExists = $false
$global:videoExists = $false
$global:selectedGame = ""
$global:selectedGameFolder = ""
$global:emulatorFolder = ""
#$global:emulator = ""
$global:logoPath = ""
$global:wheelPath = ""
$global:videoPath = ""
$global:logoExists = $false
$global:wheelExists = $false
$global:videoExists = $false
$global:cfgfile = ""
$global:emulatorTextPath = ""
$global:PCGamesIni = ""






# Event handler for the Browse button click
$browseButtonTop.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select the Hyperspin folder"
    $folderBrowser.RootFolder = [System.Environment+SpecialFolder]::MyComputer

    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        # Set the selected folder as a global variable
        $global:hyperspinLocation = $folderBrowser.SelectedPath

        # Update the label with the selected folder path
        $selectedFolderLabel.Text = $global:hyperspinLocation

        # Update the dropdown list with the found folders
        Update-CollectionsDropdown

        # Log the selected folder to the console
        Write-Host "Hyperspin Folder has been set to $global:hyperspinLocation"
    }
})


#$EmulatorLabel.Location = New-Object System.Drawing.Point(350, 355)
# Create the Emulator label and set default text (initially red)
$EmulatorLabel = New-Object System.Windows.Forms.Label
$EmulatorLabel.Text = "Emulator"
$EmulatorLabel.Location = New-Object System.Drawing.Point(350, 355)  # Positioned next to RocketLauncher
$EmulatorLabel.Size = New-Object System.Drawing.Size(200, 20)  # Increased width for readability
$EmulatorLabel.ForeColor = [System.Drawing.Color]::Red  # Default color red
$form.Controls.Add($EmulatorLabel)

# Function to populate the dropdown with folders from \collections
function Update-CollectionsDropdown {
    $collectionsDropdown.Items.Clear()  # Clear previous items
    if (Test-Path "$global:hyperspinLocation\collections") {
        $folders = Get-ChildItem -Path "$global:hyperspinLocation\collections" -Directory | Select-Object -ExpandProperty Name
        $collectionsDropdown.Items.AddRange($folders)
    }
}

# Event handler for when a collection is selected
$collectionsDropdown.Add_SelectedIndexChanged({
    # Set the global variable $global:emulator to the selected collection
    $global:emulator = $collectionsDropdown.SelectedItem

    # Update the EmulatorLabel text dynamically based on the selected emulator
    if ($global:emulator) {
        $EmulatorLabel.Text = "$global:emulator"
        $EmulatorLabel.ForeColor = [System.Drawing.Color]::Green  # Change color to green when selected
    } else {
        $EmulatorLabel.Text = "Emulator"
        $EmulatorLabel.ForeColor = [System.Drawing.Color]::Red  # Default color red when not selected
    }

    # Optional: Output the selected emulator for debugging
    Write-Host "Emulator has been set to $global:emulator"
})

# Update label position




# Function to browse for folder
$browseButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $folderTextBox.Text = $folderBrowser.SelectedPath
        #$emulator = [System.IO.Path]::GetFileName($folderBrowser.SelectedPath)
        $global:selectedGameFolder = $folderBrowser.SelectedPath
        # Clear existing items in the dropdown
        $selectedGameDropdown.Items.Clear()
            Write-Host "ROM Foldet Path has been set to $global:selectedGameFolder"
        # Get directories in the selected folder
        $directories = Get-ChildItem -Path $folderBrowser.SelectedPath -Directory
        foreach ($dir in $directories) {
            $selectedGameDropdown.Items.Add($dir.Name)
        }

        # Show a default prompt if no games are found
        if ($selectedGameDropdown.Items.Count -eq 0) {
            $selectedGameDropdown.Items.Add("No games found in selected folder.")
        }
    }
})

$selectedGameDropdown.Add_SelectedIndexChanged({
    if ($selectedGameDropdown.SelectedItem) {
        # Assign the selected game and update the label
        $global:selectedGame = $selectedGameDropdown.SelectedItem
        Write-Host "Game: $global:selectedGame"

        # Get the full path of the selected game's folder
        $global:selectedGameFolder = Join-Path -Path $folderTextBox.Text -ChildPath $global:selectedGame
        Write-Host "Full path for selected game: $global:selectedGameFolder"

        # Get the parent folder (i.e., the emulator folder)
        $global:emulatorFolder = [System.IO.Directory]::GetParent($global:selectedGameFolder).FullName
        #$global:emulator = [System.IO.Path]::GetFileName($global:emulatorFolder)

        # Update the emulator label
        Write-Host "Emulator: $global:emulator"

        # Dynamically create media paths for logo, wheel, and video
        $global:logoPath = Join-Path -Path $global:hyperspinLocation -ChildPath "collections\$global:emulator\logo\$global:selectedGame.png"
        $global:wheelPath = Join-Path -Path $global:hyperspinLocation -ChildPath "collections\$global:emulator\wheel\$global:selectedGame.png"
        $global:videoPath = Join-Path -Path $global:hyperspinLocation -ChildPath "collections\$global:emulator\videos\$global:selectedGame.mp4"
		$global:batPath = Join-Path -Path $global:hyperspinLocation -ChildPath "collections\$global:emulator\roms\$global:selectedGame.bat"
		

        # Show available artworks first (before checking $Emulator.txt)
        $global:logoExists = Test-Path $global:logoPath
        $global:wheelExists = Test-Path $global:wheelPath
        $global:videoExists = Test-Path $global:videoPath

        if ($global:logoExists) {
            $logoPictureBox.Image = [System.Drawing.Image]::FromFile($global:logoPath)
        } else {
            Write-Host "Logo not found at $global:logoPath"
            #$logoPictureBox.Image = [System.Drawing.Image]::FromFile($global:logoPath)
        }

        if ($global:wheelExists) {
            $wheelPictureBox.Image = [System.Drawing.Image]::FromFile($global:wheelPath)
        } else {
            Write-Host "Wheel not found at $global:wheelPath"
            #$wheelPictureBox.Image = [System.Drawing.Image]::FromFile($global:wheelPath)
        }

        if ($global:videoExists) {
            try {
                $mediaElement.Source = $global:videoPath
            }
            catch {
                Write-Host "Video could not be played at $global:videoPath, displaying fallback image"
                $mediaElement.Source = $unknownMediaImg  # Display fallback image
                $artworksLabel.ForeColor = [System.Drawing.Color]::Red  # Mark as missing
            }
        } else {
            Write-Host "Video not found at $global:videoPath"
            $defaultVideoPath = "$global:hyperspinLocation\layouts\NXL HD\default.mp4"
            $mediaElement.Source = $defaultVideoPath
        }

        # Check the artwork status
        if ($global:logoExists -and $global:wheelExists -and $global:videoExists) {
            $artworksLabel.ForeColor = [System.Drawing.Color]::Green  # All artwork found
        } else {
            $artworksLabel.ForeColor = [System.Drawing.Color]::Red  # Some artwork missing
        }

        # Check if the .cfg file exists
        $global:cfgfile = Join-Path -Path $global:hyperspinLocation -ChildPath "romlists\All Systems\$global:selectedGame.cfg"
        if (Test-Path $global:cfgfile) {
            $cfgLabel.ForeColor = [System.Drawing.Color]::Green  # Green if .cfg file exists
			            Write-Host "cfg File found $global:cfgfile"
        } else {
            $cfgLabel.ForeColor = [System.Drawing.Color]::Red  # Red if .cfg file does not exist

         
            }
        
		           # Check if the .bat file exists
        $global:batPath = Join-Path -Path $global:hyperspinLocation -ChildPath "collections\$global:emulator\roms\$global:selectedGame.bat"
        if (Test-Path $global:batPath) {
            $batLabel.ForeColor = [System.Drawing.Color]::Green  # Green if .bat file exists
			            Write-Host "BAT File found $global:batPath"
        } else {
            $batLabel.ForeColor = [System.Drawing.Color]::Red  # Red if .bat file does not exist

         
            }

			
		
		

        # Dynamically determine the correct emulator.txt path based on emulator
        $global:emulatorTextPath = Join-Path -Path $global:hyperspinLocation -ChildPath "romlists\$global:emulator\$global:emulator.txt"

        if ($global:emulator -eq "PC Games") {
            # Check for the default PC Games.txt path
            $global:emulatorTextPath = "$global:hyperspinLocation\romlists\PC Games.txt"
        }

        if (Test-Path $global:emulatorTextPath) {
            Write-Host "Checking $global:emulatorTextPath for game entry with emulator: $global:emulator"
            $sectionExists = $false
            $emulatorTextLines = Get-Content $global:emulatorTextPath
            foreach ($line in $emulatorTextLines) {
                if ($line -match ".*;$global:emulator(;|$)") {
                    Write-Host "Found entry with emulator: $global:emulator"  # Log if entry is found
                    $sectionExists = $true
                    break
                }
            }

            if (-not $sectionExists) {
                Write-Host "Not Found: Emulator $global:emulator not associated with any game in $global:emulatorTextPath"  # Log if entry is not found
            }

            if ($sectionExists) {
                $romlistLabel.ForeColor = [System.Drawing.Color]::Green  # Green if section exists
            } else {
                $romlistLabel.ForeColor = [System.Drawing.Color]::Red  # Red if section does not exist
            }
        } else {
            Write-Host "$global:emulatorTextPath not found."
        }

        # RocketLauncher logic (specific to PC Games emulator)
        if ($global:emulator -eq "PC Games") {
            $global:PCGamesIni = Join-Path -Path $global:hyperspinLocation -ChildPath "RocketLauncher\Modules\PCLauncher\PC Games.ini"

            if (Test-Path $global:PCGamesIni) {
                $sectionExists = Select-String -Pattern "^\[$global:selectedGame\]" -Path $global:PCGamesIni

                if ($sectionExists) {
                    Write-Host "Section [$global:selectedGame] found in $global:PCGamesIni"
                    $rocketLauncherLabel.ForeColor = [System.Drawing.Color]::Green  # Section exists
                } else {
                    Write-Host "Section [$global:selectedGame] not found in $global:PCGamesIni"
                    $rocketLauncherLabel.ForeColor = [System.Drawing.Color]::Red  # Section missing
                }
            } else {
                Write-Host "File $global:PCGamesIni does not exist"
                $rocketLauncherLabel.ForeColor = [System.Drawing.Color]::Red  # INI file missing
            }
        }
    }
})




# Global variables to store selected exe name and full path
$global:exenamefullpath = ""
$global:exename = ""


# Debug log to console for Add button click
$addBox.Add_Click({
    Write-Host "ADD button clicked."
    
    # Ensure the selected game folder, emulator, and selected game are populated
    if (-not $selectedGameFolder) {
        Write-Host "No selected game folder found."
        [System.Windows.Forms.MessageBox]::Show("No selected game folder found.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)
        return
    }

    if (-not $global:emulator) {
        Write-Host "No emulator selected."
        [System.Windows.Forms.MessageBox]::Show("No emulator selected.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)
        return
    }

    if (-not $selectedGame) {
        Write-Host "No selected game found."
        [System.Windows.Forms.MessageBox]::Show("No selected game found.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)
        return
    }

    Write-Host "hyperspinlocation: $global:hyperspinLocation"
    Write-Host "selectedGameFolder: $selectedGameFolder"
    Write-Host "emulator: $emulator"
    Write-Host "selectedgame: $selectedGame"

    # Build the path to search for .exe files in the selected game folder
    $searchPath = $selectedGameFolder
    Write-Host "Generated path to search for .exe files: $searchPath"

    if (Test-Path $searchPath) {
        Write-Host "Path exists: $searchPath"
    } else {
        Write-Host "Path does not exist: $searchPath"
        [System.Windows.Forms.MessageBox]::Show("Path does not exist.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)
        return
    }

    # Search for .exe files
    $exeFiles = Get-ChildItem -Path $searchPath -Recurse -Filter "*.exe" -File
    Write-Host "Found $($exeFiles.Count) .exe files."









if ($exeFiles.Count -gt 0) {
    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select Executable"
    $form.Size = New-Object System.Drawing.Size(350, 350)

    # Create the ListBox
    $exeListBox = New-Object System.Windows.Forms.ListBox
    $exeListBox.Location = New-Object System.Drawing.Point(20, 20)
    $exeListBox.Size = New-Object System.Drawing.Size(500, 150)

    # Create a Label to display the full path of the selected .exe
    $pathLabel = New-Object System.Windows.Forms.Label
    $pathLabel.Location = New-Object System.Drawing.Point(20, 180)
    $pathLabel.Size = New-Object System.Drawing.Size(500, 30)
    $pathLabel.Text = "Selected path will appear here."
    $form.Controls.Add($pathLabel)

    # Create an array to store file names and full paths
    $exePaths = @{}

    foreach ($exe in $exeFiles) {
        # Add the file name to ListBox for display
        $exeListBox.Items.Add($exe.Name)  # Display only the file name in ListBox
        Write-Host "Added .exe to ListBox: $($exe.Name)"  # Show the name in console log

        # Store the full path with the file name as key
        $exePaths[$exe.Name] = $exe.FullName
    }

    # Add ListBox to form
    $form.Controls.Add($exeListBox)

    # Create OK Button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(20, 220)
    $okButton.Size = New-Object System.Drawing.Size(75, 30)
    $form.Controls.Add($okButton)

    # Create Cancel Button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Location = New-Object System.Drawing.Point(110, 220)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 30)
    $form.Controls.Add($cancelButton)

    # Event handler for ListBox selection change
    $exeListBox.Add_SelectedIndexChanged({
        if ($exeListBox.SelectedItem) {
            # Get the full path from $exePaths dictionary using the selected file name
            $selectedExeFullPath = $exePaths[$exeListBox.SelectedItem]
            
            # Update the label with the full path
            $pathLabel.Text = "Selected Path: $selectedExeFullPath"
        }
    })

    # Event handler for OK button click
    $okButton.Add_Click({
        if ($exeListBox.SelectedItem) {
            # Get the full path from $exePaths dictionary using the selected file name
            $global:exenamefullpath = $exePaths[$exeListBox.SelectedItem]
            $global:exename = $exeListBox.SelectedItem  # Only the file name (exe)
			$global:exedir = Split-Path -Path $global:exenamefullpath -Parent

            Write-Host "Selected EXE Full Path: $global:exenamefullpath"
            Write-Host "Selected EXE Name: $global:exename"

            # Optionally show the selected file in a message box
            [System.Windows.Forms.MessageBox]::Show("Adding Entry for $selectedGame Selected EXE: $global:exename", "EXE Selected", [System.Windows.Forms.MessageBoxButtons]::OK)






# Define global variables
$steam_user_data_path = "F:\Program Files (x86)\Steam\userdata\345901489\config"
$game_installation_path = "$global:hyperspinLocation\collections\PC Games\roms\Contra Operation Galuga"
$game_exe_path = "$global:hyperspinLocation\collections\PC Games\roms\Contra Operation Galuga\ContraOG.exe"
$steamdir_path = "F:\Program Files (x86)\Steam"





# Check if Python is installed by running 'python --version'
$python = Get-Command python -ErrorAction SilentlyContinue
if ($python -eq $null) {
    Write-Host "Python is not installed. Downloading and installing Python 3.7.0..."

    # Set the URL and download location for Python installer
    $installerPath = "$global:hyperspinLocation\techpinoy-plugins\temp\python-3.7.0.exe"
    
    # Create temp folder if it doesn't exist
    if (-not (Test-Path "$global:hyperspinLocation\techpinoy-plugins\temp")) {
        New-Item -Path "$global:hyperspinLocation\techpinoy-plugins\temp" -ItemType Directory
    }

    # Download Python installer
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.7.0/python-3.7.0.exe" -OutFile $installerPath

    Write-Host "Installing Python 3.7.0..."

    # Install Python quietly
    Start-Process -FilePath $installerPath -ArgumentList '/quiet', 'InstallAllUsers=0', 'InstallLauncherAllUsers=0', 'PrependPath=1', 'Include_test=0' -Wait

    Write-Host "Python installation complete."

}
# Get the directory where the PowerShell script is located
if ($MyInvocation.MyCommand.Path) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    # Fallback to the current working directory if $MyInvocation.MyCommand.Path is null
    $scriptDir = $PWD.Path
}

# Path to the Python script (assuming it's in the same directory as this PowerShell script)
$pythonScriptPath = Join-Path -Path $scriptDir -ChildPath "single1.py"

# Run the Python script with the variables as arguments
python $pythonScriptPath `
    --steam_user_data_path "$global:vdffolder" `
    --game_installation_path "$global:selectedGameFolder" `
    --game_exe_path "$global:exenamefullpath" `
    --steamdir_path "$global:steamdir"












# Create the ReShade file content
$ReShadeINIContent = @"
[GENERAL]
EffectSearchPaths=$global:hyperspinLocation\techpinoy-plugins\reshade-shaders\Shaders
IntermediateCachePath=$global:hyperspinLocation\Temp\ReShade
NoDebugInfo=1
NoEffectCache=0
NoReloadOnInit=0
PerformanceMode=1
PreprocessorDefinitions=
PresetPath=$global:hyperspinLocation\techpinoy-plugins\Preset - Nostalgia - ZneonZ.ini
PresetShortcutKeys=
PresetShortcutPaths=
PresetTransitionDuration=1000
SkipLoadingDisabledEffects=0
StartupPresetPath=
TextureSearchPaths=$global:hyperspinLocation\techpinoy-plugins\reshade-shaders\Textures

[OVERLAY]
AutoSavePreset=1
FPSPosition=1
ShowForceLoadEffectsButton=1
ShowFPS=2
TutorialProgress=4
VariableListHeight=200.000000
VariableListUseTabs=0
"@

# Determine the path for the ReShade file
$ReShadeFilePath = Join-Path -Path $global:exedir -ChildPath 'ReShade.ini'
$ReShadeINIPath = $ReShadeFilePath

# Create or overwrite the .bat file
$ReShadeINIContent | Set-Content -Path $ReShadeINIPath -Force
Write-Host "Updated $ReShadeFilePath"


# Create the batch file content
$batFileContent = @"
$batFileContent = @"
@echo off
setlocal
set "GAMENAME_URL=$global:selectedGame.url"
set "GAMENAME_EXE=$global:exename"
set "GAMEPATH=$global:exenamefullpath"
set "LOGFILE=$global:gamelog"
set HOME="%~dp0"
set "GAMEROOT=%~dp0%GAMEPATH%"
set "GAMEDRIVE=$global:driveLetter"

rem Clear previous log or create a new one
echo Script execution started. > "%LOGFILE%"

rem Check if the URL file exists on the user's desktop
if exist "%USERPROFILE%\Desktop\%GAMENAME_URL%" (
    echo Found %GAMENAME_URL% on Desktop. >> "%LOGFILE%"
    echo Running %GAMENAME_URL% from Desktop...
    start "" /WAIT "%USERPROFILE%\Desktop\%GAMENAME_URL%"
    echo Successfully executed %GAMENAME_URL% from Desktop. >> "%LOGFILE%"
) else (
    rem Check if the URL file exists in the specified game path
    if exist "%GAMEPATH%" (
        echo Found %GAMENAME_EXE%. >> "%LOGFILE%"
        echo Running %GAMENAME_EXE%...
        start "" /WAIT "%GAMEPATH%"
        echo Successfully executed %GAMENAME_EXE%. >> "%LOGFILE%"
    ) else (
        echo %GAMENAME_URL% not found. Proceeding to run the EXE file. >> "%LOGFILE%"
        echo Running %GAMENAME_EXE%...
        start "" /WAIT "%GAMEPATH%"
        echo Successfully executed %GAMENAME_EXE%. >> "%LOGFILE%"
    )
)

echo Script execution finished. >> "%LOGFILE%"
echo Logs written to %LOGFILE%.
exit
"@

# Determine the path for the batch file
$batchFilePath = Join-Path -Path $global:hyperspinLocation -ChildPath "collections\$global:emulator\roms\$global:selectedGame.bat"
#$batFilePath = Join-Path -Path $global:selectedGameFolder -ChildPath "$global:selectedGame.bat"
$batFilePath = $batchFilePath

# Create or overwrite the .bat file
$batFileContent | Set-Content -Path $batFilePath -Force

# Display the file creation in console
Write-Host "Batch file created at: $batFilePath"
Write-Host "Batch file content: $batFileContent"
		           # Check if the .bat file exists
        $global:batPath = Join-Path -Path $global:hyperspinLocation -ChildPath "collections\$global:emulator\roms\$global:selectedGame.bat"
        if (Test-Path $global:batPath) {
            $batLabel.ForeColor = [System.Drawing.Color]::Green  # Green if .bat file exists
			            Write-Host "BAT File found $global:batPath"
        } else {
            $batLabel.ForeColor = [System.Drawing.Color]::Red  # Red if .bat file does not exist

         
            }
# Initialize default values
$game_genre = "Arcade"
$platform = "$global:emulator"
$release_year = "1984"

# Define the file paths
$allSystemsFilePath = Join-Path -Path $global:hyperspinLocation -ChildPath "romlists\All Systems.txt"
$emulatorFilePath = Join-Path -Path $global:hyperspinLocation -ChildPath "romlists\$global:emulator.txt"

# Define the pattern to search for
$pattern = [regex]::Escape("$global:selectedGame") + ";.*;$global:emulator"

# Function to check and add entry if not found
function Add-GameEntryIfNeeded {
    param (
        [string]$filePath
    )

    if (Test-Path $filePath) {
        # Read the content of the file
        $fileContent = Get-Content $filePath

        # Check if the pattern exists
        $existingEntry = $fileContent | Where-Object { $_ -match $pattern }

        if (-not $existingEntry) {
            # If the entry doesn't exist, add a new one
            $entry = "$global:selectedGame;$global:selectedGame;$global:emulator;$release_year;$platform;$game_genre;;;;;0;;;;;;;;;"
            Add-Content -Path $filePath -Value $entry
            Write-Host "Added new entry to $($filePath): $entry"
        } else {
            Write-Host "Entry already exists in $($filePath)."
        }
    } else {
        Write-Host "File not found: $filePath"
    }
}





















































# Check both All Systems.txt and Emulator-specific txt files
Add-GameEntryIfNeeded -filePath $allSystemsFilePath
Add-GameEntryIfNeeded -filePath $emulatorFilePath
				
	# Assuming $global:selectedGame, $global:exename, $global:exenamefullpath, $global:foldername are set
$PCGamesIni = $global:PCGamesIni

# Check if the section [$global:selectedGame] already exists
$sectionExists = Select-String -Pattern "^\[$global:selectedGame\]" -Path $PCGamesIni

if ($sectionExists) {
    Write-Host "Section [$global:selectedGame] already exists in $PCGamesIni. Updating..."

    # Read the content of the INI file
    $iniContent = Get-Content -Path $PCGamesIni

    # Locate the section
    $startIndex = $iniContent.IndexOf("[$global:selectedGame]")
    if ($startIndex -ne -1) {
        # Find where the section ends
        $endIndex = ($iniContent[$startIndex..($iniContent.Count - 1)] | Select-String -Pattern "^\[" -SimpleMatch -List).LineNumber - 2
        if (-not $endIndex) { $endIndex = $iniContent.Count - 1 } # If it's the last section, endIndex is the last line

        # Replace the first few lines in the section (you can adjust this based on your exact structure)
        $iniContent[$startIndex + 1] = "Application=$batchFilePath"
        $iniContent[$startIndex + 2] = "AppWaitExe=$global:exename"
        $iniContent[$startIndex + 3] = "ExitMethod=Process Close AppWaitExe"
    }

    # Write updated content back to the file
    $iniContent | Set-Content -Path $PCGamesIni -Encoding UTF8
    Write-Host "Updated Application and AppWaitExe for $global:selectedGame in $PCGamesIni"
} else {
    Write-Host "Section [$global:selectedGame] does not exist in $PCGamesIni. Appending..."

    # If section does not exist, append the new section to the INI file
    $newSection = @"
[$global:selectedGame]
Application=$batchFilePath
AppWaitExe=$global:exename
ExitMethod=Process Close AppWaitExe
PostLaunchSleep=120000
FadeTitleWaitTillActive=false
FadeTitleTimeout=120000
HideConsole=true
"@

    # Append the section to the PC Games.ini file
    Add-Content -Path $PCGamesIni -Value $newSection
    Write-Host "Appended INI section for $global:selectedGame to $PCGamesIni"
}
			
				
				
	








	
				
				
				
				        # Check if the .cfg file exists
        $global:cfgfile = Join-Path -Path $global:hyperspinLocation -ChildPath "romlists\All Systems\$global:selectedGame.cfg"
        if (Test-Path $global:cfgfile) {
            $cfgLabel.ForeColor = [System.Drawing.Color]::Green  # Green if .cfg file exists
        } else {
            $cfgLabel.ForeColor = [System.Drawing.Color]::Red  # Red if .cfg file does not exist

            # If the emulator is "PC Games", create the .cfg file with the specified content
            if ($global:emulator -eq "PC Games") {
                $cfgContent = @"
executable           RocketLauncher\RocketLauncher.exe
args                 -s "[emulator]" -r "[name]" -p AttractMode -f "..\HyperSpin Attraction.exe"
"@
                Set-Content -Path $global:cfgfile -Value $cfgContent
                Write-Host "Created .cfg file at $global:cfgfile"
                $cfgLabel.ForeColor = [System.Drawing.Color]::Green  # Update label to green after creation
            }
        }
                $form.Close()  # Close the form after selection
            } else {
                [System.Windows.Forms.MessageBox]::Show("No EXE selected. Please select an EXE file.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)
            }
        })

        # Event handler for Cancel button click
        $cancelButton.Add_Click({
            Write-Host "Operation canceled."
            $form.Close()  # Close the form without selecting any EXE
        })

        # Show the form
        $form.ShowDialog()
    } else {
        Write-Host "No .exe files found."
        [System.Windows.Forms.MessageBox]::Show("No EXE files found!", "Search Result", [System.Windows.Forms.MessageBoxButtons]::OK)
    }
})

















# Add Click event handlers for the logo PictureBox
$logoPictureBox.Add_Click({
    # Create a new form for logo image URL or path input
    $logoForm = New-Object System.Windows.Forms.Form
    $logoForm.Text = "Update Logo Image"
    $logoForm.Size = New-Object System.Drawing.Size(500, 200)
    $logoForm.StartPosition = "CenterScreen"

    # Create a text box for URL or path input
    $textBoxLogo = New-Object System.Windows.Forms.TextBox
    $textBoxLogo.Location = New-Object System.Drawing.Point(10, 20)
    $textBoxLogo.Size = New-Object System.Drawing.Size(460, 20)
    $logoForm.Controls.Add($textBoxLogo)

    # Create an Update button
    $buttonUpdate = New-Object System.Windows.Forms.Button
    $buttonUpdate.Text = "Update"
    $buttonUpdate.Location = New-Object System.Drawing.Point(10, 60)
    $buttonUpdate.Size = New-Object System.Drawing.Size(100, 30)
    $logoForm.Controls.Add($buttonUpdate)

    # Create a Scrap button
    $buttonScrap = New-Object System.Windows.Forms.Button
    $buttonScrap.Text = "Scrap"
    $buttonScrap.Location = New-Object System.Drawing.Point(120, 60)
    $buttonScrap.Size = New-Object System.Drawing.Size(100, 30)
    $logoForm.Controls.Add($buttonScrap)

    # Create a Back button
    $buttonBack = New-Object System.Windows.Forms.Button
    $buttonBack.Text = "Back"
    $buttonBack.Location = New-Object System.Drawing.Point(230, 60)
    $buttonBack.Size = New-Object System.Drawing.Size(100, 30)
    $logoForm.Controls.Add($buttonBack)

    # Define the Scrap button functionality
 



# Define the Scrap logo button functionality













$buttonScrap.Add_Click({
    # Validate API key
    $apiKey = "03c3bdbbc7922e3e4c25936f4c4e7dcb"
    if (-not $apiKey) {
        [System.Windows.Forms.MessageBox]::Show("Please provide a valid SteamGridDB API key.", "API Key Missing", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Get the selected game
    $selectedGame = $selectedGameDropdown.SelectedItem
    if (-not $selectedGame) {
        [System.Windows.Forms.MessageBox]::Show("Please select a game from the dropdown.", "Game Not Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    # Function to fetch images and update the FlowLayoutPanel
    function UpdateResults {
        param ($searchQuery, $flowPanel, $previewBox)

        # Clear existing controls
        $flowPanel.Controls.Clear()

        # API URL to search for game grids
        $apiUrl = "https://www.steamgriddb.com/api/v2/search/autocomplete/$searchQuery circle logo"

        try {
            # Make API call to fetch game data
            $response = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{
                "Authorization" = "Bearer $apiKey"
            }
            $gameId = $response.data[0].id
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error retrieving game data. Please check your API key or game name.", "API Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # Get grid images for the selected game
        $gridUrl = "https://www.steamgriddb.com/api/v2/grids/game/$gameId"
        try {
            $gridResponse = Invoke-RestMethod -Uri $gridUrl -Method Get -Headers @{
                "Authorization" = "Bearer $apiKey"
            }
            $images = $gridResponse.data | ForEach-Object { $_.url }
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error retrieving images. Please try again later.", "Image Fetch Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # Handle no images found
        if (-not $images) {
            [System.Windows.Forms.MessageBox]::Show("No images found for the entered game.", "No Results", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            return
        }

        # Populate images in the FlowLayoutPanel
        foreach ($imageUrl in $images) {
            $imageBox = New-Object System.Windows.Forms.PictureBox
            $imageBox.Size = New-Object System.Drawing.Size(150, 150)
            $imageBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
            $imageBox.ImageLocation = $imageUrl
            $imageBox.Tag = $imageUrl

            # Add border and hover effects
            $imageBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
            $imageBox.Add_Click({
                $selectedImageUrl = $this.Tag
                $previewBox.ImageLocation = $selectedImageUrl
                $textBoxLogo.Text = $selectedImageUrl
                [System.Windows.Forms.Clipboard]::SetText($selectedImageUrl)

                # Close the results form after selection
                $scrapForm.Close()
            })
            $imageBox.Add_MouseEnter({
                $this.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
            })
            $imageBox.Add_MouseLeave({
                $this.BorderStyle = [System.Windows.Forms.BorderStyle]::None
            })

            $flowPanel.Controls.Add($imageBox)
        }
    }

    # Create a new form for displaying the images
    $scrapForm = New-Object System.Windows.Forms.Form
    $scrapForm.Text = "SteamGridDB Results"
    $scrapForm.Size = New-Object System.Drawing.Size(800, 700)
    $scrapForm.StartPosition = "CenterScreen"

    # Create a FlowLayoutPanel to hold the images
    $flowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $flowPanel.Size = New-Object System.Drawing.Size(780, 500)
    $flowPanel.Location = New-Object System.Drawing.Point(10, 10)
    $flowPanel.AutoScroll = $true
    $scrapForm.Controls.Add($flowPanel)

    # Create a PictureBox to show the preview of the selected image
    $previewBox = New-Object System.Windows.Forms.PictureBox
    $previewBox.Size = New-Object System.Drawing.Size(200, 200)
    $previewBox.Location = New-Object System.Drawing.Point(10, 520)
    $previewBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $scrapForm.Controls.Add($previewBox)

    # Create a TextBox for manual search input
    $manualSearchBox = New-Object System.Windows.Forms.TextBox
    $manualSearchBox.Size = New-Object System.Drawing.Size(400, 30)
    $manualSearchBox.Location = New-Object System.Drawing.Point(230, 520)
    $scrapForm.Controls.Add($manualSearchBox)

    # Create a Button for triggering a manual search
    $searchButton = New-Object System.Windows.Forms.Button
    $searchButton.Text = "Search"
    $searchButton.Size = New-Object System.Drawing.Size(100, 30)
    $searchButton.Location = New-Object System.Drawing.Point(650, 520)
    $scrapForm.Controls.Add($searchButton)

    # Add click event for manual search
    $searchButton.Add_Click({
        $manualSearchQuery = $manualSearchBox.Text
        if (-not $manualSearchQuery) {
            [System.Windows.Forms.MessageBox]::Show("Please enter a game name to search.", "Input Missing", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        } else {
            UpdateResults -searchQuery $manualSearchQuery -flowPanel $flowPanel -previewBox $previewBox
        }
    })

    # Initial population of results using the selected game
    UpdateResults -searchQuery $selectedGame -flowPanel $flowPanel -previewBox $previewBox

    # Show the results form
    [void]$scrapForm.ShowDialog()
})





















    # Define the Update button functionality
    $buttonUpdate.Add_Click({
        $logoInput = $textBoxLogo.Text  # Store user input in a separate variable

        # Define the destination path for the logo image
        $destinationPathIMG = $global:logoPath

        # Remove the current image from the PictureBox
        $logoPictureBox.Image.Dispose()
        $logoPictureBox.Image = $null
        Write-Host "Removed existing image from PictureBox."

        try {
            # Check if a URL is provided for the logo image
            if ($logoInput -match "^https://") {
                Write-Host "Downloading image $logoInput"

                # If it's a URL, download the image
                $webClient = New-Object System.Net.WebClient
                $tempPath = [System.IO.Path]::GetTempFileName()
                $webClient.DownloadFile($logoInput, $tempPath)

                Write-Host "Image downloaded to temporary file: $tempPath"

                # Resize the image to the desired dimensions (adjust as needed)
                Add-Type -AssemblyName System.Drawing
                $image = [System.Drawing.Image]::FromFile($tempPath)
                $resizedImage = New-Object System.Drawing.Bitmap(512, 512)  # Adjust dimensions as needed
                $graphics = [System.Drawing.Graphics]::FromImage($resizedImage)
                $graphics.DrawImage($image, 0, 0, 512, 512)

                Write-Host "Image resized to 405x100 pixels."

                # Ensure the destination directory exists
                $destinationDir = Split-Path -Path $destinationPathIMG -Parent
                if (-not (Test-Path $destinationDir)) {
                    New-Item -ItemType Directory -Path $destinationDir | Out-Null
                    Write-Host "Created destination directory: $destinationDir"
                }

                # Save the resized image
                $resizedImage.Save($destinationPathIMG, [System.Drawing.Imaging.ImageFormat]::Png)

                Write-Host "Resized image saved to: $destinationPathIMG"

                # Clean up
                $image.Dispose()
                $resizedImage.Dispose()
                $graphics.Dispose()
                Remove-Item -Path $tempPath

                # Load the new image into the existing PictureBox
                $logoPictureBox.Image = [System.Drawing.Image]::FromFile($destinationPathIMG)
                Write-Host "New image loaded into PictureBox."
                Write-Host "Logo image updated successfully!"
            } else {
                # If it's a local file path, resize and save the image
                if (Test-Path $logoInput) {
                    Write-Host "Loading image from local file..."

                    Add-Type -AssemblyName System.Drawing
                    $image = [System.Drawing.Image]::FromFile($logoInput)
                    $resizedImage = New-Object System.Drawing.Bitmap(512, 512)  # Adjust dimensions as needed
                    $graphics = [System.Drawing.Graphics]::FromImage($resizedImage)
                    $graphics.DrawImage($image, 0, 0, 512, 512)

                    Write-Host "Image resized to 405x100 pixels."

                    # Ensure the destination directory exists
                    $destinationDir = Split-Path -Path $destinationPathIMG -Parent
                    if (-not (Test-Path $destinationDir)) {
                        New-Item -ItemType Directory -Path $destinationDir | Out-Null
                        Write-Host "Created destination directory: $destinationDir"
                    }

                    # Save the resized image
                    $resizedImage.Save($destinationPathIMG, [System.Drawing.Imaging.ImageFormat]::Png)

                    Write-Host "Resized image saved to: $destinationPathIMG"

                    # Clean up
                    $image.Dispose()
                    $resizedImage.Dispose()
                    $graphics.Dispose()

                    Write-Host "Logo image updated successfully!"
                } else {
                    Write-Host "The specified file path is not valid!"
                }
            }
        } catch {
            Write-Host "An error occurred: $_"
        }

        # Close the logo form after updating
        $logoForm.Close()
    })

    # Define the Back button functionality
    $buttonBack.Add_Click({
        $logoForm.Close()  # Close the logo form without making any changes
    })

    # Show the logo form
    $logoForm.Add_Shown({$logoForm.Activate()})
    [void]$logoForm.ShowDialog()
})


# Add Click event handlers for the Wheel Box
$wheelPictureBox.Add_Click({
    # Create a new form for wheel image URL or path input
    $wheelForm = New-Object System.Windows.Forms.Form
    $wheelForm.Text = "Update Wheel Image"
    $wheelForm.Size = New-Object System.Drawing.Size(500, 200)
    $wheelForm.StartPosition = "CenterScreen"

    # Create a text box for URL or path input
    $textBoxWheel = New-Object System.Windows.Forms.TextBox
    $textBoxWheel.Location = New-Object System.Drawing.Point(10, 20)
    $textBoxWheel.Size = New-Object System.Drawing.Size(460, 20)
    $wheelForm.Controls.Add($textBoxWheel)

    # Create an Update button
    $buttonUpdate = New-Object System.Windows.Forms.Button
    $buttonUpdate.Text = "Update"
    $buttonUpdate.Location = New-Object System.Drawing.Point(10, 60)
    $buttonUpdate.Size = New-Object System.Drawing.Size(100, 30)
    $wheelForm.Controls.Add($buttonUpdate)

    # Create a Scrap button
    $buttonScrap = New-Object System.Windows.Forms.Button
    $buttonScrap.Text = "Scrap"
    $buttonScrap.Location = New-Object System.Drawing.Point(120, 60)
    $buttonScrap.Size = New-Object System.Drawing.Size(100, 30)
    $wheelForm.Controls.Add($buttonScrap)

    # Create a Back button
    $buttonBack = New-Object System.Windows.Forms.Button
    $buttonBack.Text = "Back"
    $buttonBack.Location = New-Object System.Drawing.Point(230, 60)
    $buttonBack.Size = New-Object System.Drawing.Size(100, 30)
    $wheelForm.Controls.Add($buttonBack)
# Define the Scrap button functionality


$buttonScrap.Add_Click({
     # Validate API key
    $apiKey = "03c3bdbbc7922e3e4c25936f4c4e7dcb"
    if (-not $apiKey) {
        [System.Windows.Forms.MessageBox]::Show("Please provide a valid SteamGridDB API key.", "API Key Missing", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Get the selected game
    $selectedGame = $selectedGameDropdown.SelectedItem
    if (-not $selectedGame) {
        [System.Windows.Forms.MessageBox]::Show("Please select a game from the dropdown.", "Game Not Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    # Function to fetch images and update the FlowLayoutPanel
    function UpdateResults {
        param ($searchQuery, $flowPanel, $previewBox)

        # Clear existing controls
        $flowPanel.Controls.Clear()

        # API URL to search for game grids
        $apiUrl = "https://www.steamgriddb.com/api/v2/search/autocomplete/$searchQuery"

        try {
            # Make API call to fetch game data
            $response = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{
                "Authorization" = "Bearer $apiKey"
            }
            $gameId = $response.data[0].id
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error retrieving game data. Please check your API key or game name.", "API Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # Get grid images for the selected game
        $gridUrl = "https://www.steamgriddb.com/api/v2/grids/game/$gameId"
        try {
            $gridResponse = Invoke-RestMethod -Uri $gridUrl -Method Get -Headers @{
                "Authorization" = "Bearer $apiKey"
            }
            $images = $gridResponse.data | ForEach-Object { $_.url }
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error retrieving images. Please try again later.", "Image Fetch Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # Handle no images found
        if (-not $images) {
            [System.Windows.Forms.MessageBox]::Show("No images found for the entered game.", "No Results", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            return
        }

        # Populate images in the FlowLayoutPanel
        foreach ($imageUrl in $images) {
            $imageBox = New-Object System.Windows.Forms.PictureBox
            $imageBox.Size = New-Object System.Drawing.Size(150, 150)
            $imageBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
            $imageBox.ImageLocation = $imageUrl
            $imageBox.Tag = $imageUrl

            # Add border and hover effects
            $imageBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
            $imageBox.Add_Click({
                $selectedImageUrl = $this.Tag
                $previewBox.ImageLocation = $selectedImageUrl
                $textBoxWheel.Text = $selectedImageUrl
                [System.Windows.Forms.Clipboard]::SetText($selectedImageUrl)

                # Close the results form after selection
                $scrapForm.Close()
            })
            $imageBox.Add_MouseEnter({
                $this.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
            })
            $imageBox.Add_MouseLeave({
                $this.BorderStyle = [System.Windows.Forms.BorderStyle]::None
            })

            $flowPanel.Controls.Add($imageBox)
        }
    }

    # Create a new form for displaying the images
    $scrapForm = New-Object System.Windows.Forms.Form
    $scrapForm.Text = "SteamGridDB Results"
    $scrapForm.Size = New-Object System.Drawing.Size(800, 700)
    $scrapForm.StartPosition = "CenterScreen"

    # Create a FlowLayoutPanel to hold the images
    $flowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $flowPanel.Size = New-Object System.Drawing.Size(780, 500)
    $flowPanel.Location = New-Object System.Drawing.Point(10, 10)
    $flowPanel.AutoScroll = $true
    $scrapForm.Controls.Add($flowPanel)

    # Create a PictureBox to show the preview of the selected image
    $previewBox = New-Object System.Windows.Forms.PictureBox
    $previewBox.Size = New-Object System.Drawing.Size(200, 200)
    $previewBox.Location = New-Object System.Drawing.Point(10, 520)
    $previewBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $scrapForm.Controls.Add($previewBox)

    # Create a TextBox for manual search input
    $manualSearchBox = New-Object System.Windows.Forms.TextBox
    $manualSearchBox.Size = New-Object System.Drawing.Size(400, 30)
    $manualSearchBox.Location = New-Object System.Drawing.Point(230, 520)
    $scrapForm.Controls.Add($manualSearchBox)

    # Create a Button for triggering a manual search
    $searchButton = New-Object System.Windows.Forms.Button
    $searchButton.Text = "Search"
    $searchButton.Size = New-Object System.Drawing.Size(100, 30)
    $searchButton.Location = New-Object System.Drawing.Point(650, 520)
    $scrapForm.Controls.Add($searchButton)

    # Add click event for manual search
    $searchButton.Add_Click({
        $manualSearchQuery = $manualSearchBox.Text
        if (-not $manualSearchQuery) {
            [System.Windows.Forms.MessageBox]::Show("Please enter a game name to search.", "Input Missing", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        } else {
            UpdateResults -searchQuery $manualSearchQuery -flowPanel $flowPanel -previewBox $previewBox
        }
    })

    # Initial population of results using the selected game
    UpdateResults -searchQuery $selectedGame -flowPanel $flowPanel -previewBox $previewBox

    # Show the results form
    [void]$scrapForm.ShowDialog()
})

# Define the Update button functionality
$buttonUpdate.Add_Click({
    $wheelInput = $textBoxWheel.Text  # Store user input in a separate variable

    # Define the destination path for the wheel image
    $destinationPathIMG = $global:wheelPath
        # Remove the current image from the PictureBox
        $wheelPictureBox.Image.Dispose()
        $wheelPictureBox.Image = $null
        Write-Host "Removed existing image from PictureBox."
    try {
        # Check if a URL is provided for the wheel image
        if ($wheelInput -match "^https://") {
            Write-Host "Downloading image $wheelInput"

            # If it's a URL, download the image
            $webClient = New-Object System.Net.WebClient
            $tempPath = [System.IO.Path]::GetTempFileName()
            $webClient.DownloadFile($wheelInput, $tempPath)

            Write-Host "Image downloaded to temporary file: $tempPath"

            # Resize the image to 405x100 pixels
            Add-Type -AssemblyName System.Drawing
            $image = [System.Drawing.Image]::FromFile($tempPath)
            $resizedImage = New-Object System.Drawing.Bitmap(405, 100)
            $graphics = [System.Drawing.Graphics]::FromImage($resizedImage)
            $graphics.DrawImage($image, 0, 0, 405, 100)

            Write-Host "Image resized to 405x100 pixels."

            # Ensure the destination directory exists
            $destinationDir = Split-Path -Path $destinationPathIMG -Parent
            if (-not (Test-Path $destinationDir)) {
                New-Item -ItemType Directory -Path $destinationDir | Out-Null
                Write-Host "Created destination directory: $destinationDir"
            }

            # Save the resized image
            $resizedImage.Save($destinationPathIMG, [System.Drawing.Imaging.ImageFormat]::Png)

            Write-Host "Resized image saved to: $destinationPathIMG"

            # Clean up
            $image.Dispose()
            $resizedImage.Dispose()
            $graphics.Dispose()
            Remove-Item -Path $tempPath
        # Load the new image into the existing PictureBox
        $wheelPictureBox.Image = [System.Drawing.Image]::FromFile($destinationPathIMG)
        Write-Host "New image loaded into PictureBox."
            Write-Host "Wheel image updated successfully!"
        } else {
            # If it's a local file path, resize and save the image
            if (Test-Path $wheelInput) {
                Write-Host "Loading image from local file..."

                Add-Type -AssemblyName System.Drawing
                $image = [System.Drawing.Image]::FromFile($wheelInput)
                $resizedImage = New-Object System.Drawing.Bitmap(405, 100)
                $graphics = [System.Drawing.Graphics]::FromImage($resizedImage)
                $graphics.DrawImage($image, 0, 0, 405, 100)

                Write-Host "Image resized to 405x100 pixels."

                # Ensure the destination directory exists
                $destinationDir = Split-Path -Path $destinationPathIMG -Parent
                if (-not (Test-Path $destinationDir)) {
                    New-Item -ItemType Directory -Path $destinationDir | Out-Null
                    Write-Host "Created destination directory: $destinationDir"
                }

                # Save the resized image
                $resizedImage.Save($destinationPathIMG, [System.Drawing.Imaging.ImageFormat]::Png)

                Write-Host "Resized image saved to: $destinationPathIMG"

                # Clean up
                $image.Dispose()
                $resizedImage.Dispose()
                $graphics.Dispose()

                   Write-Host "Wheel image updated successfully!"
            } else {
                Write-Host "The specified file path is not valid!"
            }
        }
    } catch {
        Write-Host "An error occurred: $_"
    }

    # Close the wheel form after updating
        $wheelForm.Close()
    })

    # Define the Back button functionality
    $buttonBack.Add_Click({
        $wheelForm.Close()  # Close the wheel form without making any changes
    })

    # Show the wheel form
    $wheelForm.Add_Shown({$wheelForm.Activate()})
    [void]$wheelForm.ShowDialog()
})

$mediaElement.Add_MouseLeftButtonDown({
    # Create a new form for video URL or path input
    $videoForm = New-Object System.Windows.Forms.Form
    $videoForm.Text = "Update Video"
    $videoForm.Size = New-Object System.Drawing.Size(400, 150)
    $videoForm.StartPosition = "CenterScreen"

    # Create a text box for URL or path input
    $textBoxVideo = New-Object System.Windows.Forms.TextBox
    $textBoxVideo.Location = New-Object System.Drawing.Point(10, 20)
    $textBoxVideo.Size = New-Object System.Drawing.Size(360, 20)
    $videoForm.Controls.Add($textBoxVideo)

    # Create an Update button
    $buttonUpdate = New-Object System.Windows.Forms.Button
    $buttonUpdate.Text = "Update"
    $buttonUpdate.Location = New-Object System.Drawing.Point(10, 60)
    $buttonUpdate.Size = New-Object System.Drawing.Size(100, 30)
    $videoForm.Controls.Add($buttonUpdate)

    # Create a Back button
    $buttonBack = New-Object System.Windows.Forms.Button
    $buttonBack.Text = "Back"
    $buttonBack.Location = New-Object System.Drawing.Point(120, 60)
    $buttonBack.Size = New-Object System.Drawing.Size(100, 30)
    $videoForm.Controls.Add($buttonBack)
    # Create an Automatic button






# Create the Automatic button
$buttonAutomatic = New-Object System.Windows.Forms.Button
$buttonAutomatic.Text = "Automatic"
$buttonAutomatic.Location = New-Object System.Drawing.Point(230, 60)
$buttonAutomatic.Size = New-Object System.Drawing.Size(100, 30)
$videoForm.Controls.Add($buttonAutomatic)
# Add click event handler for the Automatic button



# Define the Update button functionality
$buttonUpdate.Add_Click({
    Write-Host "Update button clicked!"  # Debug log
    $userVideoInput = $textBoxVideo.Text  # Store user input in a separate variable

    # Check if destination path is set
    if (-not $global:videoPath) {
        [System.Windows.Forms.MessageBox]::Show("Destination path is not defined!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $destinationPath = $global:videoPath
    Write-Host "Destination path: $destinationPath"

    # Create a progress form
    $progressForm = New-Object System.Windows.Forms.Form
    $progressForm.Text = "Updating..."
    $progressForm.Width = 300
    $progressForm.Height = 150
    $progressForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $progressForm.TopMost = $true

    # Create a ProgressBar for the form
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Width = 250
    $progressBar.Height = 30
    $progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Marquee
    $progressBar.MarqueeAnimationSpeed = 30
    $progressForm.Controls.Add($progressBar)

    # Show the progress form
    $progressForm.Show()

    # Check if a URL is provided for the video (starts with https://)
    if ($userVideoInput -match "^https://") {
        # If the destination file already exists, delete it
        if (Test-Path $destinationPath) {
            Write-Host "File already exists. Deleting the existing file: $destinationPath"
            Remove-Item -Path $destinationPath -Force  # Force deletion of the file
        }

        # yt-dlp logic
        $ytdlpPath = ".\bin\yt-dlp.exe"
        if (Test-Path $ytdlpPath) {
            $arguments = @(
                "-f", "mp4+140",
                $userVideoInput,
                "-o", "`"$global:videoPath.bak`""
            )
            Write-Host "Running yt-dlp with arguments: $arguments"
            $process = Start-Process -FilePath $ytdlpPath -ArgumentList $arguments -NoNewWindow -Wait -PassThru
            Write-Host "yt-dlp process exited with code: $($process.ExitCode)"
            if ($process.ExitCode -eq 0) {
                # Continue with ffmpeg trimming
                $ffmpegExePath = Get-ChildItem -Path ".\bin" -Recurse -Filter "ffmpeg.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
                if ($ffmpegExePath) {
                    Write-Host "ffmpeg.exe found at: $ffmpegExePath"
                    # Define FFmpeg arguments for trimming
                    $ffmpegArguments = @(
                        "-i", "`"$global:videoPath.bak`"",
                        "-ss", "00:00:05",
                        "`"$destinationPath`""
                    )
                    Write-Host "Running FFmpeg with arguments: $ffmpegArguments"
                    $ffmpegProcess = Start-Process -FilePath $ffmpegExePath -ArgumentList $ffmpegArguments -NoNewWindow -Wait -PassThru
                    Write-Host "FFmpeg process exited with code: $($ffmpegProcess.ExitCode)"
                    if ($ffmpegProcess.ExitCode -eq 0) {
                        Remove-Item -Path "$global:videoPath.bak" -Force  # Remove the .bak file
                        [System.Windows.Forms.MessageBox]::Show("Video downloaded and trimmed successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
                    } else {
                        [System.Windows.Forms.MessageBox]::Show("Failed to trim the video.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                    }
                } else {
                    [System.Windows.Forms.MessageBox]::Show("ffmpeg.exe not found!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                }
            } else {
                [System.Windows.Forms.MessageBox]::Show("Failed to download video!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("yt-dlp.exe not found in the script directory!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } else {
        # Local file handling (copy the file)
        if (Test-Path $userVideoInput) {
            Copy-Item -Path $userVideoInput -Destination $destinationPath -Force
            [System.Windows.Forms.MessageBox]::Show("File copied to video folder.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } else {
            [System.Windows.Forms.MessageBox]::Show("The specified file path is not valid!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }

    # Close the progress form after updating
    $progressForm.Close()

    # Close the video form after updating
    $videoForm.Close()
})






$buttonAutomatic.Add_Click({
    # Silently search for ffmpeg.exe in the bin directory and its subfolders
	$binDirectory = ".\bin"
$ffmpegExePath = Get-ChildItem -Path $binDirectory -Recurse -Filter "ffmpeg.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

if ($ffmpegExePath) {
    Write-Host "ffmpeg.exe is already present at: $ffmpegExePath"
} else {
    Write-Host "ffmpeg.exe not found in the bin directory or its subfolders."

    # Prompt the user to download ffmpeg
    $response = [System.Windows.Forms.MessageBox]::Show(
        "ffmpeg.exe is missing. Would you like to download it?", 
        "Download ffmpeg", 
        [System.Windows.Forms.MessageBoxButtons]::YesNo, 
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    if ($response -eq "Yes") {
        Write-Host "Downloading and extracting ffmpeg..."

        # Create the bin directory if it doesn't exist
        if (-Not (Test-Path $binDirectory)) {
            New-Item -ItemType Directory -Path $binDirectory | Out-Null
        }

        # URL to the FFmpeg binary (replace with the actual URL)
        $ffmpegUrl = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"

        # Temporary file path for the downloaded zip
        $zipFilePath = ".\ffmpeg.zip"

        # Download the FFmpeg zip file
        Invoke-WebRequest -Uri $ffmpegUrl -OutFile $zipFilePath

        # Extract the zip file to the bin directory
        Expand-Archive -Path $zipFilePath -DestinationPath $binDirectory -Force

        # Clean up the downloaded zip file
        Remove-Item -Path $zipFilePath

        # Search for ffmpeg.exe again after extraction
        $ffmpegExePath = Get-ChildItem -Path $binDirectory -Recurse -Filter "ffmpeg.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

        if ($ffmpegExePath) {
            Write-Host "ffmpeg.exe has been downloaded and extracted to: $ffmpegExePath"

            # Set ffmpeg.exe path as a global environment variable
            [System.Environment]::SetEnvironmentVariable("FFMPEG_PATH", $ffmpegExePath, [System.EnvironmentVariableTarget]::Machine)

            Write-Host "FFMPEG_PATH environment variable has been set globally to: $ffmpegExePath"
        } else {
            Write-Host "ffmpeg.exe could not be found after extraction. Please check the downloaded files."
        }
    } else {
        Write-Host "Download canceled. Exiting script."
        Exit
    }
}
    $ffmpegPath = $ffmpegExePath 
	# Check if yt-dlp.exe exists
	# Check if yt-dlp.exe exists in the bin directory
	    $ytdlpPath = ".\bin\yt-dlp.exe"
if (-Not (Test-Path $ytdlpPath)) {
    # Prompt the user to download yt-dlp
    $response = [System.Windows.Forms.MessageBox]::Show(
        "yt-dlp is missing. Would you like to download it?", 
        "Download yt-dlp", 
        [System.Windows.Forms.MessageBoxButtons]::YesNo, 
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    if ($response -eq "Yes") {
        Write-Host "Downloading yt-dlp..."

        # Create the bin directory if it doesn't exist
        if (-Not (Test-Path ".\bin")) {
            New-Item -ItemType Directory -Path ".\bin" | Out-Null
        }

        # URL to the latest yt-dlp.exe (official GitHub release)
        $ytdlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"

        # Download yt-dlp.exe to the bin directory
        Invoke-WebRequest -Uri $ytdlpUrl -OutFile $ytdlpPath

        Write-Host "yt-dlp has been downloaded to the bin directory."
    } else {
        Write-Host "Download canceled. Exiting script."
        Exit
    }
} else {
    Write-Host "yt-dlp is already present in the bin directory."
}



    if (-Not (Test-Path $ytdlpPath)) {
        [System.Windows.Forms.MessageBox]::Show("yt-dlp.exe is missing. Please ensure it is installed in the .\bin directory.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Define the selected game and search query
    $selectedgame = "$global:selectedGame"  # Replace with the actual selected game
    $searchQuery = "$selectedgame trailer"  # Create search query

    # Search URL
    $searchUrl = "ytsearch1:$searchQuery"

    Write-Host "Search Query: $searchQuery"
    Write-Host "Search URL: $searchUrl"

    try {
        # Run yt-dlp to search YouTube and get the result as JSON
        $process = Start-Process -FilePath $ytdlpPath -ArgumentList "--flat-playlist", "-J", "`"$searchUrl`"" -RedirectStandardOutput "yt-dlp_output.json" -NoNewWindow -Wait -PassThru

        # Check if the output file exists
        if (Test-Path "yt-dlp_output.json") {
            $resultJson = Get-Content -Path "yt-dlp_output.json" -Raw
            $searchResults = $resultJson | ConvertFrom-Json

            # Check if there are any results
            if ($searchResults.entries.Count -gt 0) {
                # Get the URL of the first result
                $firstVideoUrl = $searchResults.entries[0].url
                Write-Host "First Video URL: $firstVideoUrl"

                # Set the URL in the text field
                $textBoxVideo.Text = $firstVideoUrl

                # Optionally trigger the text field to refresh visually
                $textBoxVideo.Refresh()

                # Also copy the URL to clipboard
                Set-Clipboard -Value $firstVideoUrl
                Write-Host "URL copied to clipboard."
            } else {
                [System.Windows.Forms.MessageBox]::Show("No results found for the trailer.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }

            # Clean up the output file
            Remove-Item -Path "yt-dlp_output.json" -Force
        } else {
            [System.Windows.Forms.MessageBox]::Show("Failed to capture yt-dlp output.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("An error occurred while fetching the trailer.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})













    # Define the Back button functionality
    $buttonBack.Add_Click({
        $videoForm.Close()  # Close the video form without making any changes
    })

    # Show the video form
    $videoForm.Add_Shown({$videoForm.Activate()})
    [void]$videoForm.ShowDialog()
})

# Show the main form
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
