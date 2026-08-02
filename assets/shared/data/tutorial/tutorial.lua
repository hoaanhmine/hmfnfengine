-- ============================================================
--  MODCHART HƯỚNG DẪN - HMFNF Engine
--  Xem từng hiệu ứng theo beat để hiểu cách hoạt động
-- ============================================================

local strumSize = 112

function onCreate()
	addPlayfield() -- Tạo bản sao cho demo glow

	--------------------
	-- BEAT 0-16: REVERSE + STEALTH
	--------------------
	set('reverse', 0, 1)
	ease('reverse', 8, 4, 0, 'sineOut')

	set('stealth', 0, 0, -1, 1)           -- Playfield 1: ẩn nốt
	set('stealthglowred', 0, 1, -1, 1)    -- Glow đỏ
	ease('stealth', 4, 4, 1, 'sineInOut', -1, 1)
	ease('stealthglowred', 4, 4, 0, 'sineInOut', -1, 1)

	--------------------
	-- BEAT 16-24: XOAY
	--------------------
	ease('rotateZ', 16, 4, 360, 'cubeOut')
	ease('rotateX', 20, 4, 180, 'sineInOut')
	ease('rotateY', 24, 2, 360, 'cubeIn')

	--------------------
	-- BEAT 26-32: PER-LANE
	--------------------
	ease('movex0', 26, 2, 1.5, 'backOut')
	ease('movex1', 26, 2, -1.5, 'backOut')
	ease('movex2', 28, 2, 1, 'elasticOut')
	ease('movex3', 28, 2, -1, 'elasticOut')
	ease('anglex0', 30, 2, 360, 'cubeOut')
	ease('anglex1', 30, 2, -360, 'cubeOut')
	ease('anglex2', 30, 2, 360, 'cubeOut')
	ease('anglex3', 30, 2, -360, 'cubeOut')

	--------------------
	-- BEAT 32-40: DRUNK + TIPSY
	--------------------
	ease('drunk', 32, 2, 1, 'sineInOut')
	set('drunkSpeed', 32, 2)
	ease('tipsy', 34, 4, 1, 'sineInOut')
	ease('drunk', 38, 2, 0, 'sineInOut')
	ease('tipsy', 38, 2, 0, 'sineInOut')

	--------------------
	-- BEAT 40-48: BOUNCE + WAVEY
	--------------------
	ease('waveyy', 40, 8, 0.6, 'sineInOut')
	ease('bounce', 40, 2, 1, 'bounceOut')
	ease('bounce', 44, 2, 0, 'bounceIn')

	--------------------
	-- BEAT 48-56: SCALE
	--------------------
	ease('zoom', 48, 4, 1.5, 'cubeInOut')
	ease('scaleX', 48, 2, 0.5, 'sineOut')
	ease('scaleY', 50, 2, 0.5, 'sineOut')
	ease('tiny', 52, 4, 0.3, 'elasticOut') -- per-note
	ease('zoom', 52, 4, 1, 'sineInOut')

	--------------------
	-- BEAT 56-64: TORNADO + SPIRAL
	--------------------
	ease('tornado', 56, 4, 1, 'cubeInOut')
	ease('spiral', 60, 4, 1, 'sineInOut')
	ease('tornado', 62, 2, 0, 'sineOut')
	ease('spiral', 62, 2, 0, 'sineOut')

	--------------------
	-- BEAT 64-72: INFINITE (bản sao)
	--------------------
	set('infinite', 64, 1)
	set('cull', 64, 0.4)
	ease('rotateZ', 64, 8, -360, 'linear')
	ease('cull', 68, 4, 0.8, 'sineOut')
	set('infinite', 72, 0)
	set('cull', 72, 0)

	--------------------
	-- BEAT 72-80: SUDDEN
	--------------------
	ease('sudden', 72, 4, 1, 'sineInOut')
	ease('suddenStart', 72, 4, 2, 'sineInOut')
	ease('sudden', 76, 4, 0, 'sineInOut')

	--------------------
	-- BEAT 80-88: CAROUSEL + CENTERED
	--------------------
	ease('carousel', 80, 4, 1, 'cubeInOut')
	ease('centered', 80, 4, 1, 'sineOut')
	ease('flip', 84, 4, 0.5, 'sineInOut')
	ease('carousel', 84, 4, 0, 'cubeIn')

	--------------------
	-- BEAT 88-96: BUMPY + CUBIC
	--------------------
	ease('bumpy', 88, 4, 1, 'bounceOut')
	ease('bumpyx', 88, 4, 1, 'bounceOut')
	ease('cubicx', 92, 4, 0.5, 'sineInOut')
	set('cubicxOffset', 92, 300)
	ease('bumpy', 92, 4, 0, 'sineIn')
	ease('bumpyx', 92, 4, 0, 'sineIn')

	--------------------
	-- BEAT 96-104: PATH
	--------------------
	ease('arrowPathAlpha', 96, 2, 0.8, 'sineOut')
	set('arrowPathThickness', 96, 3)
	ease('skewX', 98, 4, 0.5, 'sineInOut')
	ease('skewY', 98, 4, 0.3, 'sineInOut')
	ease('arrowPathAlpha', 102, 2, 0, 'sineOut')
	ease('skewX', 102, 2, 0, 'sineOut')
	ease('skewY', 102, 2, 0, 'sineOut')

	--------------------
	-- BEAT 104-112: BEAT SCALE
	--------------------
	set('beatMult', 104, 0.3)
	set('beatScale', 104, 1)
	ease('beat', 104, 8, 1, 'bounceOut')
	ease('beatScale', 104, 8, 1, 'bounceOut')
	set('beatScaleAlternate', 104, 1)
	ease('beat', 112, 2, 0, 'sineOut')
	ease('beatScale', 112, 2, 0, 'sineOut')

	--------------------
	-- BEAT 112-120: DANCE COMBO
	--------------------
	for i = 112, 120, 2 do
		add('rotateZ', i, 1, 45, 'backOut')
		add('waveyy', i, 1, 0.3, 'bounceOut')
		add('tiny', i, 1, -0.2, 'backOut')
		add('tiny', i+1, 1, -0.2, 'backOut')
		add('flip', i, 1, -0.15, 'backOut')
	end

	--------------------
	-- BEAT 120-128: GLOW OUTRO
	--------------------
	set('stealth', 120, 0, -1, 1)
	set('stealthglowblue', 120, 1, -1, 1)
	ease('stealthglowblue', 120, 8, 0, 'sineInOut', -1, 1)
	ease('alpha', 124, 4, 0, 'sineIn')
	ease('rotateZ', 124, 4, 180, 'sineIn')
end
