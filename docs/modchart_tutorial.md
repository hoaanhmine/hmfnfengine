# Hướng dẫn làm Modchart từ A-Z

## 1. Modchart là gì?

Modchart là script Lua giúp bạn tạo hiệu ứng chuyển động cho nốt nhạc và receptor. Bạn có thể làm nốt xoay tròn, nhảy múa, bay lơ lửng, phóng to thu nhỏ,... theo nhịp bài hát.

---

## 2. Cách tạo modchart

### Bước 1: Tạo file

Đặt file `.lua` vào thư mục:
```
assets/data/<tên bài hát>/<tên>.lua
```
Ví dụ: `assets/data/looping/looping.lua`

### Bước 2: Bật modchart

Trong file `.json` của bài hát, thêm:
```json
"modchart": true
```

### Bước 3: Viết script

```lua
function onCreate()
    -- Modchart sẽ chạy ở đây
end
```

---

## 3. Cấu trúc cơ bản

Mỗi modchart có 3 hàm chính:

```lua
function onCreate()
    -- Chạy 1 lần khi vào bài hát
end

function onSongStart()
    -- Chạy khi bài hát bắt đầu
end

function onBeatHit()
    -- Chạy mỗi khi đập nhịp
end
```

---

## 4. Ba hàm timeline quan trọng nhất

### `set(tên, beat, giá_trị, player?, field?)`
**Đặt giá trị modifier tại 1 beat cụ thể** (giữ nguyên đến hết bài hoặc đến khi bị thay đổi)

```lua
set('reverse', 0, 1)     -- Đảo hướng từ beat 0
set('reverse', 16, 0)    -- Tắt reverse từ beat 16
set('stealth', 32, 1)    -- Ẩn nốt từ beat 32
```

### `ease(tên, beat, độ_dài, giá_trị, easing?, player?, field?)`
**Chuyển đổi từ từ** từ giá trị hiện tại đến giá trị mới trong khoảng beat

```lua
-- reverse từ 0→100% trong 8 beat (bắt đầu từ beat 0)
ease('reverse', 0, 8, 1, 'cubeInOut')

-- drunk từ 100→0% trong 4 beat (bắt đầu từ beat 16)
ease('drunk', 16, 4, 0, 'sineOut')
```

### `add(tên, beat, độ_dài, giá_trị, easing?, player?, field?)`
**Cộng dồn** giá trị vào giá trị hiện tại

```lua
-- Mỗi lần gọi xoay thêm 90 độ
add('rotateZ', 0, 1, 90, 'sineOut')
add('rotateZ', 1, 1, 90, 'sineOut')  -- thêm 90 nữa
```

### Tham số `player`:
| Value | Ý nghĩa |
|-------|---------|
| `-1` | Cả 2 người chơi (mặc định) |
| `0` | Đối thủ (dad) |
| `1` | Người chơi (bf) |

### Tham số `field`:
- `-1` = Tất cả playfield (mặc định)
- `0` = Playfield đầu tiên
- `1` = Playfield thứ 2 (sau khi gọi `addPlayfield()`)

### Các easing name:
```
linear, quadIn, quadOut, quadInOut,
cubeIn, cubeOut, cubeInOut,
sineIn, sineOut, sineInOut,
bounceIn, bounceOut, bounceInOut,
elasticIn, elasticOut, elasticInOut,
backIn, backOut, backInOut,
smootherstepIn, smootherstepOut, smootherstepInOut
```

---

## 5. Nhóm modifier theo mục đích

### Hiệu ứng xoay

```lua
rotateZ     -- Xoay quanh trục Z (mặt phẳng màn hình)
rotateX     -- Xoay lật ngang
rotateY     -- Xoay lật dọc
angleZ      -- Xoay từng nốt (giống rotateZ)
anglex      -- Xoay từng nốt trục X
angley      -- Xoay từng nốt trục Y
roll        -- Xoay cuộn từng nốt
holdanglex  -- Xoay hold trục X
holdangley  -- Xoay hold trục Y
```

```lua
-- Ví dụ: Xoay nốt bay vòng
ease('rotateZ', 0, 16, 360, 'cubeInOut')
ease('rotateX', 0, 16, 180, 'sineInOut')
```

### Hiệu ứng di chuyển

```lua
movex       -- Dịch X (từng lane: movex0, movex1, movex2, movex3)
movey       -- Dịch Y (từng lane)
x, y, z     -- Dịch toàn bộ nốt
yd          -- Khoảng cách Y giữa các nốt
circx       -- Chuyển động vòng tròn X
circy       -- Chuyển động vòng tròn Y
waveyx      -- Sóng ngang
waveyy      -- Sóng dọc
tipsy       -- Rung nhẹ
bumpy       -- Nhảy theo sóng sin
bumpyx      -- Nhảy ngang
cubicx      -- Cubic path X
```

```lua
-- Ví dụ: Nốt bay vào từ hai bên
set('x', 0, -500, 1)      -- Dịch trái
ease('x', 0, 8, 0, 'backOut', 1)  -- Về vị trí

-- Ví dụ: Sóng dọc
ease('waveyy', 0, 16, 0.5, 'sineInOut')
```

### Hiệu ứng scale

```lua
zoom        -- Zoom toàn bộ
scale       -- Scale tổng quát
scaleX      -- Scale trục X
scaleY      -- Scale trục Y
tiny        -- Thu nhỏ từng nốt
beat        -- Phóng to theo beat
beatMult    -- Hệ số beat
beatScale   -- Scale theo beat
```

```lua
-- Ví dụ: Nốt phóng to dần
ease('zoom', 0, 16, 2, 'expoOut')
ease('zoom', 16, 8, 1, 'sineOut')
```

### Hiệu ứng ẩn/hiện

```lua
stealth           -- Ẩn nốt (0 = ẩn, 1 = hiện)
stealthglowred    -- Màu đỏ glow khi ẩn
stealthglowgreen  -- Màu xanh lá glow
stealthglowblue   -- Màu xanh dương glow
alpha             -- Độ trong suốt
cull              -- Ẩn theo khoảng cách
sudden            -- Ẩn đột ngột
suddenStart       -- Điểm bắt đầu sudden
suddenEnd         -- Điểm kết thúc sudden
```

```lua
-- Ví dụ: Ẩn nốt + glow xanh
set('stealth', 0, 0)
set('stealthglowgreen', 0, 1)

-- Ví dụ: Sudden dần
ease('sudden', 0, 16, 1, 'sineInOut')
```

### Hiệu ứng đặc biệt

```lua
reverse           -- Đảo hướng cuộn
invert            -- Đảo hướng 1 phần
flip              -- Lật nốt
centered          -- Căn giữa
confusion         -- Làm rối
drunk             -- Xoay say rượu
drunkSpeed        -- Tốc độ drunk
drugged           -- Say thuốc
tornado           -- Lốc xoáy
spiral            -- Xoáy ốc
carousel          -- Xoay vòng
infinite          -- Nhân bản nốt vô tận
boost             -- Boost tốc độ
bounce            -- Nảy dọc
```

```lua
-- Ví dụ: Làm nốt say rượu
ease('drunk', 0, 4, 1, 'sineInOut')
set('drunkSpeed', 0, 3)  -- Tăng tốc độ

-- Ví dụ: Nhân bản nốt
set('infinite', 0, 1)
set('cull', 0, 0.5)  -- Cắt bớt bản sao
```

### Đường path

```lua
arrowPathAlpha      -- Độ trong của path
arrowPathThickness  -- Độ dày path
arrowPathRed        -- Màu path (R)
arrowPathGreen      -- Màu path (G)
arrowPathBlue       -- Màu path (B)
```

---

## 6. Kỹ thuật per-lane

Thêm số 0-3 vào cuối tên modifier để tác động lên từng lane:

```lua
-- Lane 0 (trái nhất), 1, 2, 3 (phải nhất)
ease('movex0', 0, 4, 1, 'backOut')    -- Lane 0 dịch phải
ease('movex1', 0, 4, -1, 'backOut')   -- Lane 1 dịch trái
ease('anglex0', 0, 4, 360, 'cubeOut') -- Lane 0 xoay
```

---

## 7. Multiple Playfield

Dùng `addPlayfield()` để tạo bản sao của nốt, áp dụng mod khác nhau:

```lua
function onCreate()
    addPlayfield()  -- Tạo playfield thứ 2
    
    -- Playfield 0: hiệu ứng xoay
    ease('rotateZ', 0, 16, 180, 'sineInOut', -1, 0)
    
    -- Playfield 1: hiệu ứng thu nhỏ + fade
    set('alpha', 0, 0.3, -1, 1)
    ease('tiny', 0, 16, 0.5, 'sineInOut', -1, 1)
end
```

Chú ý: Modifier ghi đè lên playfield sau. Hay dùng `player` hoặc `field` để phân biệt.

---

## 8. Dùng callback

```lua
function gunEffect(when)
    set('stealth', when, 0.5)
    ease('stealth', when, 0.1, 0, 'quintOut')
    ease('stealth', when+2, 0.1, 0.5, 'quintOut')
    
    add('rotateZ', when, 1, -12, 'bounceOut')
    add('rotateZ', when+1, 1, 12, 'bounceOut')
end

function onCreate()
    gunEffect(18)
    gunEffect(146)
end
```

---

## 9. Ví dụ hoàn chỉnh

### Modchart: "Bay vòng"

```lua
local strumSize = 112

function onCreate()
    -- Bay vào từ ngoài màn hình
    set('x', 0, strumSize * -3, 1)
    ease('x', 0, 8, 0, 'backOut', 1)
    
    -- Xoay vòng
    ease('rotateZ', 8, 16, 360, 'cubeInOut')
    
    -- Phóng to theo beat
    set('beatMult', 8, 0.5)
    ease('beat', 8, 1, 1, 'expoOut')
    
    -- Hiệu ứng say rượu
    ease('drunk', 24, 4, 1, 'sineInOut')
    set('drunkSpeed', 24, 2)
    
    -- Kết thúc: ẩn dần
    ease('stealth', 32, 8, 0, 'sineInOut')
end
```

### Modchart: "Vũ điệu ánh sáng"

```lua
function onCreate()
    addPlayfield()  -- Bản sao để tạo hiệu ứng glow
    
    -- Nốt chính: xoay bay
    ease('rotateZ', 0, 32, -720, 'cubeInOut', 1, 0)
    ease('waveyy', 0, 32, 0.5, 'sineInOut', 1, 0)
    
    -- Bản sao: glow xanh, mờ dần
    set('stealth', 0, 0, 1, 1)     -- Ẩn nốt
    set('stealthglowgreen', 0, 1, 1, 1)  -- Glow xanh
    set('alpha', 0, 0.3, 1, 1)    -- Mờ
    ease('rotateZ', 0, 32, 720, 'cubeInOut', 1, 1)
end
```

---

## 10. Mẹo & Troubleshooting

| Vấn đề | Giải pháp |
|--------|-----------|
| Modchart không chạy | Kiểm tra `"modchart": true` trong .json |
| Lỗi "Unknown modifier" | Kiểm tra chính tả tên modifier |
| Modifier không có tác dụng | Kiểm tra `player` và `field` có đúng không |
| Hiệu ứng giật lag | Dùng `ease` thay vì `set` từng beat |
| Nốt biến mất khi dùng infinite | Dùng `cull` để điều chỉnh tầm nhìn |

```lua
-- Debug: in giá trị modifier
debugPrint(getPercent('drunk', 1))  -- In ra giá trị drunk của P1
```

---

## 11. Danh sách modifier đầy đủ

Xem file `modchart_guide.md` để có danh sách đầy đủ tất cả modifier kèm mô tả.
