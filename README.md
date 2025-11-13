<div align="center">

# Linux Hardening Script 🛡️  
**سرور لینوکس رو ضد هک کن – در ۲ دقیقه!**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/Language-Bash-critical)](harden.sh)
[![Ubuntu](https://img.shields.io/badge/Tested-Ubuntu_22.04-success)](#)
[![Stars](https://img.shields.io/github/stars/yourname/linux-hardening?style=social)](#)

![Hardening Demo](screenshots/demo.gif)

</div>

---

## قبل و بعد از اجرا

| قبل | بعد |
|------|------|
| ![Before](screenshots/before.png) | ![After](screenshots/after.png) |

> **نتیجه:** از سرور ناامن → **قلعه غیرقابل نفوذ!**

---

## ویژگی‌ها

| قابلیت | وضعیت |
|--------|-------|
| بروزرسانی سیستم | ✅ |
| غیرفعال کردن root | ✅ |
| تغییر پورت SSH | اختیاری |
| نصب Fail2Ban | ✅ |
| فایروال خودکار | ✅ |
| بکاپ خودکار | ✅ |
| گزارش HTML | ✅ |

---

## نصب و اجرا

```bash
git clone https://github.com/programer-75/linux-hardening.git
cd linux-hardening
chmod +x harden.sh
sudo ./harden.sh
