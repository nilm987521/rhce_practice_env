# RHCE練習環境(Docker)
本環境會建立自帶`systmed`(非privileged模式)的且會啟動`sshd`容器

## 建立Image
```bash
# 需要有REDHAT訂閱的帳號/密碼，執行下列指令前載入環境變數
docker build --secret id=REDHAT_USERNAME,env=REDHAT_USERNAME --secret id=REDHAT_PASSWORD,env=REDHAT_PASSWORD -t rhce .
```

## 啟動所有容器
```bash
docker compose up -d
```
