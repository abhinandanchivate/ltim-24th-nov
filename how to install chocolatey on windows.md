Here you go Abhi — **the clean, correct, and updated way to install Chocolatey (choco) on Windows**.

---

# ✅ **How to Install Chocolatey on Windows (Step-by-Step)**

Chocolatey is a **Windows package manager** (like apt/yum/brew) used to install apps via CLI.

---

# 🟦 **1. Open PowerShell as Administrator**

### 👉 Steps:

1. Click **Start**
2. Type **PowerShell**
3. Right-click → **Run as Administrator**
4. Confirm **Yes** on UAC popup

---

# 🟧 **2. Allow PowerShell to Execute Scripts**

Run this command:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

---

# 🟩 **3. Install Chocolatey**

Copy & paste the official installation command:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

---

# 🟦 **4. Close and Reopen PowerShell**

Now run:

```powershell
choco --version
```

You should see something like:

```
1.4.0
```

That means **Chocolatey is installed successfully**.

---

# 🎯 OPTIONAL (Recommended)

### ✔ Enable global confirmation so you don’t need `-y` every time:

```powershell
choco feature enable -n allowGlobalConfirmation
```

### ✔ Install a test package:

```powershell
choco install git
```

---

# 🟪 Common Problems & Fixes

### ❗ Proxy or SSL error

Set TLS 1.2 manually:

```powershell
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
```

### ❗ Execution policy blocked

```powershell
Set-ExecutionPolicy AllSigned
```

OR for session only:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### ❗ Corporate Wi-Fi blocking packages

Connect to **personal hotspot** or switch DNS to **1.1.1.1** or **8.8.8.8**.

---

# If you want

🔹 How to use choco
🔹 How to create your own choco package
🔹 How to uninstall choco
🔹 How to install apps like VSCode, Node, Python, Docker using choco

Just tell me — I’ll provide that too.
