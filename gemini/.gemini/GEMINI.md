# Gemini CLI Configuration
Language: Traditional Chinese (繁體中文)
Instruction: Always verify that the user's request is understood and respond in Traditional Chinese (繁體中文).

---
這份學習清單是專為**「短期衝刺面試」且針對「AGV/機器人控制軟體」**職位設計的。

我們不學老舊的 C++ (C with Classes)，直接學現代 C++ (Modern C++, C++11/14/17)。這樣最快，也最符合業界需求。

請依照這 5 個階段進行，每個階段都有**「觀念」與「實作練習」**。

第一階段：脫離 C 語言思維 (現代基礎)
目標： 忘掉 printf, char*, malloc，學會用 C++ 的方式處理資料。

輸入輸出 (I/O)

學會 std::cout (輸出) 和 std::cin (輸入)。

重點：別再用 printf，因為 cout 會自動判斷型別，更安全。

型別推導 (auto)

學會用 auto 讓編譯器自己猜型別。

例如：auto a = 10; (它是 int), auto b = 3.14; (它是 double)。

為什麼學： 後面寫 Iterator 或樣板時，型別名字超長，用 auto 救命。

參考 (&) 與 const (非常重要)

傳值 (Pass by Value): void func(int a) (複製一份，慢)。

傳參考 (Pass by Reference): void func(int &a) (直接用原本的，快，可修改)。

常數參考 (Pass by const Reference): void func(const int &a) (直接用原本的，快，不可修改)。

面試考點： 「如果我要傳一個很大的圖片資料給函式，參數該怎麼寫？」(答案：const Image& img)。

✅ 第一階段練習： 寫一個函式 printString(const std::string& s)，用 cin 讀入名字，丟進函式印出來。

第二階段：標準容器與字串 (丟掉陣列)
目標： 永遠不要再寫 int arr[100] 這種固定大小的陣列。

std::string

它會自動調整大小，可以像數字一樣相加 (s1 + s2)。

學會：.size(), .empty(), .c_str() (如果要跟舊 C 語言庫溝通時用)。

std::vector (動態陣列)

這是 C++ 最強的武器。

學會：.push_back() (塞資料), .size(), 透過 [] 存取。

學會：Range-based for loop (現代迴圈)。

C++

for (const auto& item : myVector) { ... }
std::queue (佇列)

先進先出 (FIFO)。AGV 任務排隊必用。

學會：.push(), .front() (看第一個), .pop() (丟掉第一個)。

✅ 第二階段練習： 建立一個 vector<int>，塞入 1 到 10，然後用 Range-based for loop 印出所有數字。

第三階段：物件導向與記憶體管理 (核心)
目標： 看懂 class 並且絕對不發生記憶體洩漏 (Memory Leak)。

類別 (Class) 基礎

建構子 (Constructor): 物件生出來時自動跑的。

解構子 (Destructor ~Class): 物件死掉前自動跑的 (收屍用)。

public (大家都能用) vs private (只有自己能用)。

RAII (資源取得即初始化)

這是 C++ 哲學。利用「物件死掉會自動呼叫解構子」的特性，來自動關閉檔案、釋放記憶體、解鎖 Mutex。

智慧指標 (Smart Pointers)

std::unique_ptr: 獨佔擁有，出了 {} 自動釋放。 (90% 的情況都用這個)。

std::shared_ptr: 共享擁有，透過計數器決定何時釋放。

禁止使用： 裸指標 (int* p = new int;) 除非你有非常強的理由，否則面試時看到 new 就要警鈴大作。

✅ 第三階段練習： 寫一個 Class，建構子印出 "Start"，解構子印出 "End"。在 main 裡面用 { } 包住它，觀察是否離開括號就自動印出 "End"。

第四階段：多執行緒與併發 (面試決勝點)
目標： 控制 AGV 的同時，還要能接收指令，程式不能卡死。

執行緒 (std::thread)

如何啟動一個背景任務。

.join() (等待結束) 與 .detach() (放生，通常不建議)。

互斥鎖 (std::mutex)

保護共享資料（例如 taskQueue）。

std::lock_guard: 自動上鎖解鎖 (RAII)。

條件變數 (std::condition_variable)

wait: 等待通知 (不吃 CPU)。

notify_one: 叫醒一個執行緒。

觀念： 解決「生產者-消費者」問題。

Lambda 表達式

[](){ ... } 這種寫法。在 thread 或算法中常用來寫那種「只用一次的小函式」。

✅ 第四階段練習： (這就是我給你的那個 AGV 專案程式碼，請把每一行都對應到這個觀念清單)。

第五階段：專案建置與工具 (實戰力)
目標： 在 Ubuntu 上活下來。

CMake 基礎

project(), add_executable(), target_link_libraries()。

知道 CMakeLists.txt 是藍圖，cmake 是工頭，make 是工人。

基本 Linux 指令

ls, cd, mkdir, rm, top (看 CPU 用量)。
