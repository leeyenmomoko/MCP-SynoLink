# Docker 構建錯誤修復文檔

## 問題描述

在 Docker 構建過程中，遇到以下錯誤：

```
> [release 6/7] RUN npm ci --omit=dev:
0.935
0.935 > mcp-synolink@1.0.0 prepare
0.935 > npm run build
0.935
1.006
1.006 > mcp-synolink@1.0.0 build
1.006 > tsc && chmod +x dist/index.js
1.006
1.008 sh: tsc: not found
1.027 npm error code 127
1.027 npm error path /app
1.027 npm error command failed
1.027 npm error command sh -c npm run build
```

錯誤發生在 Dockerfile 的第 22 行：`RUN npm ci --omit=dev`

## 問題分析

1. **package.json 分析**：

   - 在 scripts 部分定義了 `"prepare": "npm run build"` 和 `"build": "tsc && chmod +x dist/index.js"`
   - TypeScript (`typescript`) 被列為開發依賴 (devDependencies)

2. **Dockerfile 分析**：

   - 使用多階段構建 (multi-stage build)
   - 第一階段 (builder)：安裝所有依賴並構建應用程序
   - 第二階段 (release)：從 builder 階段複製構建好的文件，並安裝僅生產依賴

3. **錯誤原因**：
   - 在第二階段執行 `npm ci --omit=dev` 時，npm 會自動執行 prepare 腳本
   - prepare 腳本嘗試執行 build 腳本，需要 TypeScript 編譯器 (tsc)
   - 由於使用了 `--omit=dev`，TypeScript 編譯器沒有被安裝，導致錯誤

## 解決方案

修改 Dockerfile 第 22 行，在 `npm ci --omit=dev` 命令中添加 `--ignore-scripts` 參數：

```dockerfile
RUN npm ci --omit=dev --ignore-scripts
```

這個修改的作用是：

- 防止 npm 在安裝過程中執行 prepare 腳本
- 避免嘗試使用不存在的 TypeScript 編譯器
- 保持多階段構建的優勢，只在第二階段安裝生產依賴

## 其他可能的解決方案

1. 將 TypeScript 移到 dependencies 而不是 devDependencies

   - 缺點：增加生產環境的依賴大小

2. 修改 Dockerfile，在第二階段直接複製 node_modules 目錄

   - 缺點：可能包含不必要的開發依賴

3. 修改 package.json，移除 prepare 腳本或修改它不依賴 build 腳本
   - 缺點：可能影響開發工作流程

## 結論

選擇使用 `--ignore-scripts` 參數是最小侵入性的解決方案，不需要修改 package.json 或改變構建邏輯，只需在 Dockerfile 中添加一個參數即可解決問題。
