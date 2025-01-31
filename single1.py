import os
import vdf
import logging
import zlib
import argparse
from pathlib import Path

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Parse command-line arguments
parser = argparse.ArgumentParser(description="Update Steam shortcuts for a single game.")
parser.add_argument('--steam_user_data_path', required=True, help="Path to Steam user data config folder.")
parser.add_argument('--game_installation_path', required=True, help="Path to the game installation directory.")
parser.add_argument('--game_exe_path', required=True, help="Path to the game executable.")
parser.add_argument('--steamdir_path', required=True, help="Path to the Steam installation directory.")
args = parser.parse_args()

# Assign arguments to variables
steam_user_data_path = args.steam_user_data_path
game_installation_path = args.game_installation_path
game_exe_path = args.game_exe_path
steamdir_path = args.steamdir_path





# Helper Functions
def get_game_name():
    """Extract the game name from the game installation path."""
    return os.path.basename(game_installation_path).lower()

def generate_appid(game_name, exe_path):
    """Generate a unique appid for the game within the valid 32-bit signed integer range."""
    # Generate a hash using CRC32
    hash_value = zlib.crc32((game_name + exe_path).encode('utf-8'))
    # Ensure the hash is within the valid range for a 32-bit signed integer
    return hash_value & 0x7FFFFFFF  # Mask to ensure it's within the range

# Main Function to Update Shortcuts
def update_shortcuts():
    """Update the Steam shortcuts for the single game."""
    shortcuts_file = os.path.join(steam_user_data_path, 'shortcuts.vdf')

    try:
        # Load existing shortcuts or create new if the file doesn't exist
        if os.path.exists(shortcuts_file):
            try:
                with open(shortcuts_file, 'rb') as f:
                    shortcuts = vdf.binary_load(f)
                # Ensure the 'shortcuts' key exists
                if 'shortcuts' not in shortcuts:
                    logger.warning("'shortcuts' key not found in shortcuts.vdf. Creating a new one.")
                    shortcuts = {'shortcuts': {}}
            except Exception as e:
                logger.error(f"Failed to load shortcuts.vdf: {e}. Creating a new one.")
                shortcuts = {'shortcuts': {}}
        else:
            logger.info("shortcuts.vdf not found. Creating a new one.")
            shortcuts = {'shortcuts': {}}

        # Get the game name from the installation path
        game_name = get_game_name()

        # Collect the current shortcuts
        existing_games = {shortcut.get('appname', '').strip().lower(): shortcut for shortcut in shortcuts['shortcuts'].values()}

        # Use the predefined game_exe_path
        if not os.path.exists(game_exe_path):
            logger.error(f"Game executable not found at {game_exe_path}.")
            return

        exe_path = game_exe_path
        appid = generate_appid(game_name, exe_path)

        # Add or update shortcut entry
        new_entry = {
            "appid": appid,  # Use the generated appid
            "appname": game_name,
            "exe": f'"{exe_path}"',
            "StartDir": f'"{game_installation_path}"',
            "LaunchOptions": "",
            "IsHidden": 0,
            "AllowDesktopConfig": 1,
            "OpenVR": 0,
            "Devkit": 0,
            "DevkitGameID": "",
            "LastPlayTime": 0,
            "tags": {}
        }

        # Check if the game already exists in shortcuts
        if game_name in existing_games:
            # Update existing shortcut
            for idx, shortcut in shortcuts['shortcuts'].items():
                if shortcut.get('appname', '').strip().lower() == game_name:
                    shortcuts['shortcuts'][idx] = new_entry
                    logger.info(f"Updated shortcut for game: {game_name}")
                    break
        else:
            # Add new shortcut
            shortcuts['shortcuts'][str(len(shortcuts['shortcuts']))] = new_entry
            logger.info(f"Added shortcut for game: {game_name}")

        # Save the updated shortcuts file
        with open(shortcuts_file, 'wb') as f:
            vdf.binary_dump(shortcuts, f)
            logger.info("Shortcuts file updated and saved.")

    except Exception as e:
        logger.error(f"Error updating shortcuts: {e}")

# Main Execution
if __name__ == "__main__":
    update_shortcuts()