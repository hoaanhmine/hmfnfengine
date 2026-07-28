# Modchart Lua - Hướng dẫn sử dụng

Modchart cho phép bạn tạo hiệu ứng chuyển động cho các nốt nhạc (arrow notes) và receptor trong quá trình chơi, sử dụng Lua script.

## Cách sử dụng

Đặt file `.lua` vào thư mục `data/<tên bài hát>/` (phân biệt chữ hoa/thường). Ví dụ:
```
mods/song/data/song-song/song.lua
assets/data/song-song/song.lua
```

Để kích hoạt modchart, trong file `.json` của bài hát, thêm trường:
```json
"modchart": true
```

## API Functions

### Quản lý Modifier

#### `setPercent(name, value, player?, field?)`
Đặt giá trị phần trăm của modifier ngay lập tức.
- `name` - Tên modifier
- `value` - Giá trị (0.0 = tắt, 1.0 = 100%)
- `player` - 0 (đối thủ), 1 (người chơi), -1 (cả hai). Mặc định: -1
- `field` - Playfield ID. Mặc định: -1

Ví dụ:
```lua
setPercent('drunk', 0.5, 1)  -- Drunk 50% cho người chơi
setPercent('reverse', 1)      -- Reverse cho cả hai
```

#### `getPercent(name, player?, field?)`
Lấy giá trị phần trăm hiện tại.
- `player` Mặc định: 0
- `field` Mặc định: 0

#### `setRawValue(name, value, player?, field?)`
Đặt giá trị raw (thường dùng cho hệ thống nội bộ).

#### `getRawValue(name, player?, field?)`
Lấy giá trị raw.

### Timeline Events (dựa trên beat)

#### `set(nameOrMods, beat, value, player?, field?)`
Lên lịch đặt modifier tại một beat cụ thể.

```lua
set('drunk', 16, 1)                    -- Drunk 100% tại beat 16
set('reverse', 32, 0, 1)               -- Tắt reverse cho P1 tại beat 32
set({drunk=0.5, reverse=1}, 8, -1)     -- Nhiều modifier cùng lúc
```

#### `ease(nameOrMods, beat, length, value, ease?, player?, field?)`
Tạo hiệu ứng chuyển đổi (easing) từ giá trị hiện tại đến giá trị mới.

```lua
ease('drunk', 0, 16, 1, 'quadInOut')     -- Drunk 0→100% trong 16 beat
ease('drunk', 16, 8, 0, 'sineOut')       -- Drunk 100→0% trong 8 beat
```

Các ease name: `linear`, `quadIn`, `quadOut`, `quadInOut`, `cubeIn`, `cubeOut`, `cubeInOut`, `sineIn`, `sineOut`, `sineInOut`, `bounceIn`, `bounceOut`, `bounceInOut`, `elasticIn`, `elasticOut`, `elasticInOut`, `backIn`, `backOut`, `backInOut`.

#### `add(nameOrMods, beat, length, value, ease?, player?, field?)`
Tương tự ease nhưng CỘNG dồn giá trị vào giá trị hiện tại.

#### `setAdd(nameOrMods, beat, value, player?, field?)`
Giống `set` nhưng dùng dạng additive (cộng dồn).

### Now variants (sử dụng beat hiện tại)

#### `setNow(nameOrMods, value, player?, field?)`
Đặt modifier ngay lập tức ở beat hiện tại.

#### `easeNow(nameOrMods, length, value, ease?, player?, field?)`
Ease ngay lập tức từ beat hiện tại.

#### `addNow(nameOrMods, length, value, ease?, player?, field?)`
Add ngay lập tức từ beat hiện tại.

#### `setAddNow(nameOrMods, value, player?, field?)`
setAdd ngay lập tức ở beat hiện tại.

### Callbacks & Repeaters

#### `scheduleCallback(beat, funcName, field?)`
Gọi một hàm Lua tại beat cụ thể.

```lua
function myFunc()
    debugPrint('Hello at beat 16!')
end
scheduleCallback(16, 'myFunc')
```

#### `repeater(beat, length, funcName, field?)`
Gọi hàm lặp lại mỗi beat trong khoảng thời gian.

```lua
function tick()
    debugPrint('Tick!')
end
repeater(0, 32, 'tick')  -- Gọi tick mỗi beat từ beat 0 đến 32
```

### Playfield

#### `addPlayfield()`
Thêm một playfield mới. Có thể dùng để split notes sang nhiều field.

### Alias

#### `alias(name, aliasName, field)`
Tạo bí danh cho tên modifier.

### Parsing

#### `parseITGModstring(modStr, startStep?, player?, field?)`
Parse một ITG modstring. Cú pháp: `"<level> *<speed> <mod>"`. Nếu không có speed, đặt ngay lập tức. Nếu có speed, ease với linear.

```lua
parseITGModstring("1 100% 2 0% *2 reverse", 0, -1)  -- 100%→0% reverse trong 2 steps
parseITGModstring("1 reverse", 0)                     -- Reverse 100% ngay step 0
```

### Utility

#### `getCurrentBeat()` - Beat hiện tại
#### `getCurrentStep()` - Step hiện tại
#### `getSongPosition()` - Vị trí bài hát (ms)
#### `getBPM()` - BPM hiện tại
#### `getPlayerCount()` - Số người chơi
#### `getArrowSize()` - Kích thước arrow mặc định
#### `getArrowSizeDiv2()` - Arrow size / 2
#### `getHoldSize()` - Kích thước hold
#### `getHoldSizeDiv2()` - Hold size / 2

#### `getRenderedStrumPosition(strum, field?)` - Lấy vị trí thực tế của strum sau khi mod

## Danh sách Modifier

| Tên | Mô tả |
|---------|------|
| `drunk` | Xoay nốt kiểu say rượu |
| `drunkSpeed` | Tốc độ hiệu ứng drunk |
| `drunkx` | Drunk trên trục X |
| `tipsy` | Xoay nốt rung nhẹ |
| `bumpy` | Dịch chuyển nốt dọc theo sin |
| `bumpyx` | Bumpy trên trục X |
| `bumpyAngle` | Xoay góc theo bumpy |
| `bumpyAngleOffset` | Offset góc bumpy |
| `bumpyXMult` | Hệ số bumpy X |
| `bounce` | Dịch chuyển dọc |
| `beat` | Phóng to theo beat |
| `beatMult` | Hệ số beat |
| `beatScale` | Scale theo beat |
| `beatScaleMult` | Hệ số beat scale |
| `beatScaleAlternate` | Beat scale đan xen |
| `boost` | Boost tốc độ |
| `carousel` | Xoay vòng |
| `centerrotate` | Xoay quanh tâm |
| `cubic` | Hiệu ứng cubic |
| `cubicx` | Cubic trên trục X |
| `cubicxOffset` | Offset cubic X |
| `cubicz` | Cubic trên trục Z |
| `digital` | Số hóa |
| `drugged` | Hiệu ứng như say thuốc |
| `invert` | Đảo ngược hướng một phần |
| `reverse` | Đảo ngược hướng cuộn |
| `rotate` / `rotateZ` | Xoay toàn bộ (trục Z) |
| `rotateX` | Xoay trục X |
| `rotateY` | Xoay trục Y |
| `rotateZOffset` | Tâm xoay trục Z |
| `rotateXOffset` | Tâm xoay trục X |
| `rotateYOffset` | Tâm xoay trục Y |
| `scale` | Thay đổi kích thước |
| `scaleX` | Scale trục X |
| `scaleY` | Scale trục Y |
| `sawtooth` | Răng cưa |
| `skew` / `skewX` | Kéo xiên trục X |
| `skewY` | Kéo xiên trục Y |
| `square` | Vuông hóa |
| `stealth` | Làm nốt biến mất |
| `stealthglowred` | Màu đỏ glow khi ẩn |
| `stealthglowgreen` | Màu xanh lá glow khi ẩn |
| `stealthglowblue` | Màu xanh dương glow khi ẩn |
| `alphaSplash` | Độ trong suốt note splash |
| `tornado` | Lốc xoáy |
| `zigzag` | Zigzag |
| `zoom` | Zoom cả playfield |
| `fieldrotate` | Xoay field |
| `localrotate` | Xoay local (từng nốt) |
| `infinite` | Infinite |
| `transform` | Biến đổi tổng quát |
| `straightholds` | Bắt hold thẳng |
| `asymptote` | Asymptote |
| `attenuate` | Attenuate tổng quát |
| `attenuatex` | Attenuate trục X |
| `parabola` | Parabolic |
| `radionic` | Vô tuyến |
| `randomspeed` | Tốc độ ngẫu nhiên |
| `receptorscroll` | Scroll receptor |
| `schmovindrunk` | Drunk nâng cao |
| `schmovintipsy` | Tipsy nâng cao |
| `schmovintornado` | Tornado nâng cao |
| `arrowshape` | Shape mũi tên |
| `opponentswap` | Đổi chỗ P1/P2 |
| `pathmodifier` | Path modifier |
| `luapath` | Path từ Lua |
| `spiral` | Xoáy ốc |
| `vibrate` | Rung |
| `wiggle` | Ngoe nguẩy |
| `eyeshape` | Eye shape |
| `counterclockwise` | Ngược chiều kim đồng hồ |
| `schmovinarrowshape` | Arrow shape nâng cao |
| `notetweenangle` | Note tween góc |
| `notetweendirection` | Note tween hướng |
| `roll` | Xoay cuộn (từng nốt) |
| `tiny` | Thu nhỏ (từng nốt) |
| `centered` | Căn giữa (từng nốt) |
| `flip` | Lật (từng nốt) |
| `angle` | Xoay góc (từng nốt, alias rotateZ) |
| `angleZ` | Xoay góc trục Z (từng nốt) |
| `anglex` | Xoay góc trục X (từng nốt) |
| `angley` | Xoay góc trục Y (từng nốt) |
| `orient` | Định hướng nốt theo path |
| `orientx` | Định hướng trục X |
| `orienty` | Định hướng trục Y |
| `holdanglex` | Xoay hold trục X |
| `holdangley` | Xoay hold trục Y |
| `holdanglez` | Xoay hold trục Z |
| `cull` | Ẩn nốt theo khoảng cách |
| `circx` | Chuyển động vòng tròn X |
| `circy` | Chuyển động vòng tròn Y |
| `circz` | Chuyển động vòng tròn Z |
| `waveyx` | Sóng ngang X |
| `waveyy` | Sóng dọc Y |
| `wavezz` | Sóng Z |
| `movex` | Dịch chuyển X (từng lane) |
| `movey` | Dịch chuyển Y (từng lane) |
| `yd` | Khoảng cách Y giữa các nốt |
| `sudden` | Sudden (ẩn đột ngột) |
| `suddenStart` | Điểm bắt đầu sudden |
| `suddenEnd` | Điểm kết thúc sudden |
| `arrowPathAlpha` | Độ trong suốt đường path |
| `arrowPathThickness` | Độ dày đường path |
| `arrowPathRed` | Màu đỏ path |
| `arrowPathGreen` | Màu xanh lá path |
| `arrowPathBlue` | Màu xanh dương path |
| `noteskewx` | Skew note trục X (từng lane) |
| `extramisc` | Misc bổ sung |

> **Ghi chú:** Modifier có dạng `tênN` (ví dụ `anglex0`, `movex1`) ảnh hưởng đến lane cụ thể (0-3).

### Cách dùng với `setPercent`
```lua
function onSongStart()
    setPercent('drunk', 0.5, -1)
    setPercent('reverse', 1, 1)
end
```

### Cách dùng với `ease`
```lua
function onSongStart()
    ease('confusion', 0, 16, 1, 'quadInOut')
end
```

### Cách dùng với `set`
```lua
function onBeatHit()
    if curBeat == 16 then
        set('reverse', 16, 1)
    elseif curBeat == 32 then
        set('reverse', 32, 0)
    end
end
```

## Ghi chú

- Các modifier mặc định tác động lên cả 2 người chơi
- `player = 0` = đối thủ, `player = 1` = người chơi, `player = -1` = cả hai
- Modchart chỉ hoạt động trên nền tảng desktop
- Cần bật `"modchart": true` trong file song `.json`
