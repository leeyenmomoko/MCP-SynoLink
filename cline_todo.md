# Cline Todo

## 修復 Docker 構建錯誤

### 任務接收時間：[2025-04-21 14:08:00]

#### 任務說明

修復 Docker 構建過程中的錯誤，問題出在 `npm ci --omit=dev` 命令執行時找不到 TypeScript 編譯器。

#### 子任務

1. **分析錯誤原因**

   - 行動：檢查錯誤訊息，了解問題所在
   - 依賴項：錯誤日誌
   - 狀態：已完成
   - 註：錯誤是由於在第二階段安裝時，`prepare` 腳本嘗試執行 `npm run build`，但找不到 TypeScript 編譯器

2. **檢查 package.json**

   - 行動：檢查 package.json 文件，了解依賴關係和腳本設置
   - 依賴項：無
   - 狀態：已完成
   - 註：發現 TypeScript 被列為開發依賴，而 prepare 腳本會執行 build 腳本

3. **檢查 Dockerfile**

   - 行動：檢查 Dockerfile，了解構建過程
   - 依賴項：無
   - 狀態：已完成
   - 註：Dockerfile 使用多階段構建，第二階段使用 `npm ci --omit=dev` 跳過開發依賴

4. **修改 Dockerfile**
   - 行動：在 `npm ci --omit=dev` 命令中添加 `--ignore-scripts` 參數
   - 依賴項：Dockerfile 文件
   - 狀態：已完成
   - 註：這將防止 npm 在安裝過程中執行 prepare 腳本，避免嘗試使用不存在的 TypeScript 編譯器

#### 完成情況

所有子任務已完成，Docker 構建錯誤已修復。

## 添加 Docker 環境變數支援

### 任務接收時間：[2025-04-21 14:27:00]

#### 任務說明

目前的實作方式當使用 Docker 來運行時，沒有設置 DSM 相關變數的方法。需要修改應用程式，使其能夠同時支援命令行參數和環境變數。

#### 子任務

1. **分析當前實作方式**

   - 行動：檢查 src/index.ts、Dockerfile 和 README.md，了解當前的參數處理方式
   - 依賴項：無
   - 狀態：已完成
   - 註：目前只支援通過命令行參數傳遞 Synology DSM 的連接資訊

2. **制定修改計劃**

   - 行動：制定詳細的修改計劃，包括需要修改的文件和具體的修改內容
   - 依賴項：分析結果
   - 狀態：已完成
   - 註：計劃已記錄在 AI-docs/1745217236_docker_env_vars_plan.md 文件中

3. **修改 src/index.ts**

   - 行動：修改應用程式的參數處理邏輯，使其能夠從環境變數中獲取參數
   - 依賴項：修改計劃
   - 狀態：已完成
   - 註：已添加環境變數支援，保持向後兼容性，優先使用命令行參數

4. **修改 Dockerfile**

   - 行動：在 Dockerfile 中添加環境變數的定義
   - 依賴項：修改計劃
   - 狀態：已完成
   - 註：已添加 SYNO_URL、SYNO_USERNAME、SYNO_PASSWORD 和 SYNO_API_VERSION 環境變數

5. **更新 README.md**

   - 行動：更新文檔，說明如何使用環境變數來配置應用程式
   - 依賴項：修改計劃
   - 狀態：已完成
   - 註：已添加環境變數的說明、Docker 運行示例和 Docker Compose 示例

6. **測試**

   - 行動：測試命令行參數方式、環境變數方式和 Docker 環境變數方式
   - 依賴項：所有修改完成
   - 狀態：待處理
   - 註：需要確保命令行參數的優先級高於環境變數

#### 完成情況

已完成代碼修改，包括：

1. 修改 src/index.ts，添加環境變數支援
2. 修改 Dockerfile，添加環境變數的定義
3. 更新 README.md，添加使用環境變數的說明

待進行測試以確認功能正常。
