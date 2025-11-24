Here you go Abhi — **the FASTEST, CLEANEST, ZERO-PROBLEMS method** to run your `.ps1` script in **VS Code** and finish everything in one shot.

This is the **exact way enterprise engineers run PowerShell scripts in VS Code WITHOUT errors**.

---

# ⚡ **FASTEST WAY (ONLY 2 COMMANDS)**

### 🟩 STEP 1: Open VS Code Terminal

Press:

```
CTRL + `
```

VS Code terminal opens.

---

### 🟦 STEP 2: Bypass execution policy ONLY FOR THIS SESSION

Run this FIRST — always:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
```

This avoids all errors like:

❌ “running scripts is disabled on this system”
❌ “execution policy prevents script”

---

### 🟧 STEP 3: Run your PS1 file directly

If your script is named `setup.ps1`:

```powershell
./setup.ps1
```

OR Windows path:

```powershell
.\setup.ps1
```

🔥 **DONE. That's it.**
No admin mode, no system-wide changes.

---

# 🟪 **THIS IS THE ONLY COMBINATION YOU NEED IN VS CODE:**

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup.ps1
```

This runs **EVERY PowerShell script** with full bypass **JUST inside VS Code session**, not system-wide.

---

# 💡 WHY THIS IS BEST PRACTICE?

* It does NOT change your Windows security settings
* It does NOT require admin mode
* It does NOT modify machine-level execution policy
* It works perfectly in VS Code terminal
* It resets automatically when you close VS Code
* It works with **PowerShell 5** and **PowerShell 7 (pwsh)**

---

# 🚀 Want to make it even faster?

I can generate a **VS Code Task** so you just press:

```
CTRL + SHIFT + B
```

And VS Code runs `setup.ps1` automatically.

Just say:

👉 **"create VS Code task"**
