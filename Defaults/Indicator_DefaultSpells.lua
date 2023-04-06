local _, Cell = ...
local L = Cell.L
local I = Cell.iFuncs
local F = Cell.funcs

-------------------------------------------------
-- debuffBlacklist
-------------------------------------------------
local debuffBlacklist = {
    8326, -- 鬼魂
    160029, -- 正在复活
    255234, -- 图腾复生
    225080, -- 复生
    57723, -- 筋疲力尽
    57724, -- 心满意足
    80354, -- 时空错位
    264689, -- 疲倦
    390435, -- 筋疲力尽
    206151, -- 挑战者的负担
    195776, -- 月羽疫病
    352562, -- 起伏机动
    356419, -- 审判灵魂
    387847, -- 邪甲术
    213213, -- 伪装
}

function I:GetDefaultDebuffBlacklist()
    -- local temp = {}
    -- for i, id in pairs(debuffBlacklist) do
    --     temp[i] = GetSpellInfo(id)
    -- end
    -- return temp
    return debuffBlacklist
end

-------------------------------------------------
-- bigDebuffs
-------------------------------------------------
local bigDebuffs = {
    46392, -- 专注打击
    -----------------------------------------------
    240443, -- 爆裂
    209858, -- 死疽溃烂
    240559, -- 重伤
    -- 226512, -- 鲜血脓液（血池）
    -----------------------------------------------
    -- NOTE: Thundering Affix - Dragonflight Season 1
    396369, -- 闪电标记
    396364, -- 狂风标记
    -----------------------------------------------
    -- NOTE: Shrouded Affix - Shadowlands Season 4
    -- 373391, -- 梦魇
    -- 373429, -- 腐臭虫群
    -----------------------------------------------
    -- NOTE: Encrypted Affix - Shadowlands Season 3
    -- 尤型拆卸者
    -- 366297, -- 解构
    -- 366288, -- 猛力砸击
    -----------------------------------------------
    -- NOTE: Tormented Affix - Shadowlands Season 2
    -- 焚化者阿寇拉斯
    -- 355732, -- 融化灵魂
    -- 355738, -- 灼热爆破
    -- 凇心之欧罗斯
    -- 356667, -- 刺骨之寒
    -- 刽子手瓦卢斯
    -- 356925, -- 屠戮
    -- 356923, -- 撕裂
    -- 358973, -- 恐惧浪潮
    -- 粉碎者索苟冬
    -- 355806, -- 重压
    -- 358777, -- 痛苦之链
}

function I:GetDefaultBigDebuffs()
    return bigDebuffs
end

-------------------------------------------------
-- aoeHealings
-------------------------------------------------
local aoeHealings = {
    -- druid
    740, -- 宁静
    145205, -- 百花齐放

    -- evoker
    355916, -- 翡翠之花
    361361, -- 婆娑幼苗
    363534, -- 回溯
    367230, -- 精神之花
    370984, -- 翡翠交融
    371441, -- 赐命者之焰
    371879, -- 生生不息

    -- monk
    115098, -- 真气波
    123986, -- 真气爆裂
    115310, -- 还魂术
    -- 191837, -- 精华之泉
    322118, -- 青龙下凡 (SUMMON)

    -- paladin
    85222, -- 黎明之光
    119952, -- 弧形圣光
    114165, -- 神圣棱镜
    200654, -- 提尔的拯救
    216371, -- 复仇十字军

    -- priest
    120517, -- 光晕
    34861, -- 圣言术：灵
    596, -- 治疗祷言
    64843, -- 神圣赞美诗
    110744, -- 神圣之星
    204883, -- 治疗之环
    281265, -- 神圣新星
    314867, -- 暗影盟约
    15290, -- 吸血鬼的拥抱
    372787, -- 神言术：佑

    -- shaman
    1064, -- 治疗链
    73920, -- 治疗之雨
    108280, -- 治疗之潮图腾 (SUMMON)
    52042, -- 治疗之泉图腾 (SUMMON)
    197995, -- 奔涌之流
    157503, -- 暴雨图腾
    114911, -- 先祖指引
    382311, -- 先祖复苏
    207778, -- 倾盆大雨
    114083, -- 恢复迷雾 (升腾)
}

local aoeHealingIDs = {
    [343819] = true, -- 朱鹤下凡，朱鹤产生的“迷雾之风”的施法者是玩家
    [377509] = true, -- 梦境投影（pvp）
}

do
    local temp = {}
    for _, id in pairs(aoeHealings) do
        temp[GetSpellInfo(id)] = true
    end
    aoeHealings = temp
end

function I:IsAoEHealing(nameOrID)
    if not nameOrID then return false end
    return aoeHealings[nameOrID] or aoeHealingIDs[nameOrID]
end

local summonDuration = {
    -- evoker
    [377509] = 6, -- 梦境投影（pvp）

    -- monk
    [322118] = 25, -- 青龙下凡

    -- shaman
    [108280] = 12, -- 治疗之潮图腾
    [52042] = 15, -- 治疗之泉图腾
}

do
    local temp = {}
    for id, duration in pairs(summonDuration) do
        temp[GetSpellInfo(id)] = duration
    end
    summonDuration = temp
end

function I:GetSummonDuration(spellName)
    return summonDuration[spellName]
end

-------------------------------------------------
-- externalCooldowns
-------------------------------------------------
local externals = { -- true: track by name, false: track by id
    ["DEATHKNIGHT"] = {
        [51052] = true, -- 反魔法领域
    },

    ["DEMONHUNTER"] = {
        [196718] = true, -- 黑暗
    },

    ["DRUID"] = {
        [102342] = true, -- 铁木树皮
    },

    ["EVOKER"] = {
        [374227] = true, -- 微风
        [357170] = true, -- 时间膨胀
        [378441] = true, -- 时间停止
    },

    ["MAGE"] = {
        [198158] = true, -- 群体隐形
    },

    ["MONK"] = {
        [116849] = true, -- 作茧缚命
        [202248] = true, -- 偏转冥想
    },

    ["PALADIN"] = {
        [1022] = true, -- 保护祝福
        [6940] = true, -- 牺牲祝福
        [204018] = true, -- 破咒祝福
        [31821] = true, -- 光环掌握
        [210256] = true, -- 庇护祝福
        [228050] = false, -- 圣盾术 (被遗忘的女王护卫)
        -- [211210] = true, -- 提尔的保护
        -- [216328] = true, -- 光之优雅
    },

    ["PRIEST"] = {
        [33206] = true, -- 痛苦压制
        [47788] = true, -- 守护之魂
        [62618] = true, -- 真言术：障
        [213610] = true, -- 神圣守卫
        [197268] = true, -- 希望之光
    },

    ["ROGUE"] = {
        [114018] = true, -- 潜伏帷幕
    },

    ["SHAMAN"] = {
        [98008] = true, -- 灵魂链接图腾
        [201633] = true, -- 大地之墙图腾
        [8178] = true, -- 根基图腾
        [383018] = true, -- 石肤图腾
    },

    ["WARRIOR"] = {
        [97462] = true, -- 集结呐喊
        [3411] = true, -- 援护
        [213871] = true, -- 护卫
    },
}

function I:GetExternals()
    return externals
end

local builtInExternals = {}
local customExternals = {}

function I:UpdateExternals(t)
    -- user disabled
    wipe(builtInExternals)
    for class, spells in pairs(externals) do
        for id, trackByName in pairs(spells) do
            if not t["disabled"][id] then -- not disabled
                if trackByName then
                    local name = GetSpellInfo(id)
                    if name then
                        builtInExternals[name] = true
                    end
                else
                    builtInExternals[id] = true
                end
            end
        end
    end

    -- user created
    wipe(customExternals)
    for _, id in pairs(t["custom"]) do
        local name = GetSpellInfo(id)
        if name then
            customExternals[name] = true
        end
    end
end

local UnitIsUnit = UnitIsUnit
local bos = GetSpellInfo(6940) -- 牺牲祝福
function I:IsExternalCooldown(name, id, source, target)
    if name == bos then
        if source and target then
            -- NOTE: hide bos on caster
            return not UnitIsUnit(source, target)
        else
            return true
        end
    else
        return builtInExternals[name] or builtInExternals[id] or customExternals[name]
    end
end

-------------------------------------------------
-- defensiveCooldowns
-------------------------------------------------
local defensives = { -- true: track by name, false: track by id
    ["DEATHKNIGHT"] = {
        [48707] = true, -- 反魔法护罩
        [48792] = true, -- 冰封之韧
        [49028] = true, -- 符文刃舞
        [55233] = true, -- 吸血鬼之血
        [49039] = true, -- 巫妖之躯
        [194679] = true, -- 符文分流
    },

    ["DEMONHUNTER"] = {
        [196555] = true, -- 虚空行走
        [198589] = true, -- 疾影
        [187827] = true, -- 恶魔变形
    },

    ["DRUID"] = {
        [22812] = true, -- 树皮术
        [61336] = true, -- 生存本能
        [200851] = true, -- 沉睡者之怒
        -- [102558] = true, -- 化身：乌索克的守护者
        -- [22842] = true, -- 狂暴回复
    },

    ["EVOKER"] = {
        [363916] = true, -- 黑曜鳞片
        [374348] = true, -- 新生光焰
        [370960] = true, -- 翡翠交融
    },

    ["HUNTER"] = {
        [186265] = true, -- 灵龟守护
        [264735] = true, -- 优胜劣汰
    },

    ["MAGE"] = {
        [45438] = true, -- 寒冰屏障
        [113862] = false, -- Greater Invisibility - 强化隐形术
    },

    ["MONK"] = {
        [115176] = true, -- 禅悟冥想
        [115203] = true, -- 壮胆酒
        [122278] = true, -- 躯不坏
        [122783] = true, -- 散魔功
        [125174] = true, -- 业报之触
    },

    ["PALADIN"] = {
        [498] = true, -- 圣佑术
        [642] = true, -- 圣盾术
        [31850] = true, -- 炽热防御者
        [212641] = true, -- 远古列王守卫
        [205191] = true, -- 以眼还眼
    },

    ["PRIEST"] = {
        [47585] = true, -- 消散
        [19236] = true, -- 绝望祷言
        [586] = true, -- 渐隐术 -- TODO: 373446 通透影像
        [193065] = true, -- 防护圣光
        [27827] = true, -- 救赎之魂
    },

    ["ROGUE"] = {
        [1966] = true, -- 佯攻
        [5277] = true, -- 闪避
        [31224] = true, -- 暗影斗篷
    },

    ["SHAMAN"] = {
        [108271] = true, -- 星界转移
        [210918] = true, -- 灵体形态
    },

    ["WARLOCK"] = {
        [104773] = true, -- 不灭决心
        [212295] = true, -- 虚空守卫
    },

    ["WARRIOR"] = {
        [871] = true, -- 盾墙
        [12975] = true, -- 破釜沉舟
        [23920] = true, -- 法术反射
        [118038] = true, -- 剑在人在
        [184364] = true, -- 狂怒回复
    },
}

function I:GetDefensives()
    return defensives
end

local builtInDefensives = {}
local customDefensives = {}

function I:UpdateDefensives(t)
    -- user disabled
    wipe(builtInDefensives)
    for class, spells in pairs(defensives) do
        for id, trackByName in pairs(spells) do
            if not t["disabled"][id] then -- not disabled
                if trackByName then
                    local name = GetSpellInfo(id)
                    if name then
                        builtInDefensives[name] = true
                    end
                else
                    builtInDefensives[id] = true
                end
            end
        end
    end

    -- user created
    wipe(customDefensives)
    for _, id in pairs(t["custom"]) do
        local name = GetSpellInfo(id)
        if name then
            customDefensives[name] = true
        end
    end
end

function I:IsDefensiveCooldown(name, id)
    return builtInDefensives[name] or builtInDefensives[id] or customDefensives[name]
end

-------------------------------------------------
-- tankActiveMitigation
-------------------------------------------------
local tankActiveMitigations = {
    -- death knight
    -- 77535, -- 鲜血护盾
    195181, -- 白骨之盾

    -- demon hunter
    203720, -- 恶魔尖刺

    -- druid
    192081, -- 铁鬃

    -- monk
    215479, -- 酒醒入定

    -- paladin
    132403, -- 正义盾击

    -- warrior
    2565, -- 盾牌格挡
}

local tankActiveMitigationNames = {
    -- death knight
    -- F:GetClassColorStr("DEATHKNIGHT")..GetSpellInfo(77535).."|r", -- 鲜血护盾
    F:GetClassColorStr("DEATHKNIGHT")..GetSpellInfo(195181).."|r", -- 白骨之盾

    -- demon hunter
    F:GetClassColorStr("DEMONHUNTER")..GetSpellInfo(203720).."|r", -- 恶魔尖刺

    -- druid
    F:GetClassColorStr("DRUID")..GetSpellInfo(192081).."|r", -- 铁鬃

    -- monk
    F:GetClassColorStr("MONK")..GetSpellInfo(215479).."|r", -- 铁骨酒

    -- paladin
    F:GetClassColorStr("PALADIN")..GetSpellInfo(132403).."|r", -- 正义盾击

    -- warrior
    F:GetClassColorStr("WARRIOR")..GetSpellInfo(2565).."|r", -- 盾牌格挡
}

do
    local temp = {}
    for _, id in pairs(tankActiveMitigations) do
        temp[GetSpellInfo(id)] = true
    end
    tankActiveMitigations = temp
end

function I:IsTankActiveMitigation(name)
    return tankActiveMitigations[name]
end

function I:GetTankActiveMitigationString()
    return table.concat(tankActiveMitigationNames, ", ").."."
end

-------------------------------------------------
-- dispels
-------------------------------------------------
local dispellable = {}

function I:CanDispel(dispelType)
    return dispellable[dispelType]
end

local dispelNodeID = {
    -- DRUID ----------------
        -- 102 - Balance
        [102] = {["Curse"] = 82205, ["Poison"] = 82205},
        -- 103 - Feral
        [103] = {["Curse"] = 82204, ["Poison"] = 82204},
        -- 104 - Guardian
        [104] = {["Curse"] = 82215, ["Poison"] = 82215},
        -- Restoration
        [105] = {["Curse"] = 82203, ["Magic"] = true, ["Poison"] = 82203},
    -------------------------
    
    -- EVOKER ---------------
        -- 1467 - Devastation
        [1467] = {["Poison"] = 68689},
        -- 1468	- Preservation
        [1468] = {["Magic"] = true, ["Poison"] = true},
    -------------------------
        
    -- MAGE -----------------
        -- 62 - Arcane
        [62] = {["Curse"] = 62116},
        -- 63 - Fire
        [63] = {["Curse"] = 62116},
        -- 64 - Frost
        [64] = {["Curse"] = 62116},
    -------------------------
        
    -- MONK -----------------
        -- 268 - Brewmaster
        [268] = {["Disease"] = 81633, ["Poison"] = 81633},
        -- 269 - Windwalker
        [269] = {["Disease"] = 80606, ["Poison"] = 80606},
        -- 270 - Mistweaver
        [270] = {["Disease"] = 81634, ["Magic"] = true, ["Poison"] = 81634},
    -------------------------

    -- PALADIN --------------
        -- 65 - Holy
        [65] = {["Disease"] = 81508, ["Magic"] = true, ["Poison"] = 81508},
        -- 66 - Protection
        [66] = {["Disease"] = 81507, ["Poison"] = 81507},
        -- 70 - Retribution
        [70] = {["Disease"] = 81507, ["Poison"] = 81507},
    -------------------------
    
    -- PRIEST ---------------
        -- 256 - Discipline
        [256] = {["Disease"] = 82705, ["Magic"] = true},
        -- 257 - Holy
        [257] = {["Disease"] = 82705, ["Magic"] = true},
        -- 258 - Shadow
        [258] = {["Disease"] = 82704, ["Magic"] = 82699},
    -------------------------

    -- SHAMAN ---------------
        -- 262 - Elemental
        [262] = {["Curse"] = 81075},
        -- 263 - Enhancement
        [263] = {["Curse"] = 81077},
        -- 264 - Restoration
        [264] = {["Curse"] = 81073, ["Magic"] = true},
    -------------------------

    -- WARLOCK --------------
        -- 265 - Affliction
        -- [265] = {["Magic"] = function() return IsSpellKnown(89808, true) end},
        -- 266 - Demonology
        -- [266] = {["Magic"] = function() return IsSpellKnown(89808, true) end},
        -- 267 - Destruction
        -- [267] = {["Magic"] = function() return IsSpellKnown(89808, true) end},
    -------------------------
}

local eventFrame = CreateFrame("Frame")
--Whenever anything is committed to the configID, e.g. when saving talents, switching talent loadouts, spending profession points, etc

if UnitClassBase("player") == "WARLOCK" then
    eventFrame:RegisterEvent("UNIT_PET")

    local timer
    eventFrame:SetScript("OnEvent", function(self, event, unit)
        if unit ~= "player" then return end
        
        if timer then
            timer:Cancel()
        end
        timer = C_Timer.NewTimer(1, function()
            -- update dispellable
            dispellable["Magic"] = IsSpellKnown(89808, true)
            -- texplore(dispellable)
        end)
        
    end)
else    
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
    -- eventFrame:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")

    local function UpdateDispellable()
        -- update dispellable
        wipe(dispellable)
        local activeConfigID = C_ClassTalents.GetActiveConfigID()
        if activeConfigID and dispelNodeID[Cell.vars.playerSpecID] then
            for dispelType, value in pairs(dispelNodeID[Cell.vars.playerSpecID]) do
                if type(value) == "boolean" then
                    dispellable[dispelType] = value
                else -- number: check node info
                    local nodeInfo = C_Traits.GetNodeInfo(activeConfigID, value)
                    if nodeInfo and nodeInfo.ranksPurchased ~= 0 then
                        dispellable[dispelType] = true
                    end
                end
            end
        end

        -- texplore(dispellable)
    end

    local timer

    eventFrame:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_ENTERING_WORLD" then
            eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end

        if timer then timer:Cancel() end
        timer = C_Timer.NewTimer(1, UpdateDispellable)
    end)

    Cell:RegisterCallback("SpecChanged", "Dispellable_SpecChanged", function()
        if timer then timer:Cancel() end
        timer = C_Timer.NewTimer(1, UpdateDispellable)
    end)
end

-------------------------------------------------
-- drinking
-------------------------------------------------
local drinks = {
    170906, -- 食物和饮水
    167152, -- 进食饮水
    430, -- 喝水
    43182, -- 饮水
    172786, -- 饮料
    308433, -- 食物和饮料
    369162, -- 饮用
}

do
    local temp = {}
    for _, id in pairs(drinks) do
        temp[GetSpellInfo(id)] = true
    end
    drinks = temp
end

function I:IsDrinking(name)
    return drinks[name]
end

-------------------------------------------------
-- healer 
-------------------------------------------------
local spells =  {
    -- druid
    8936, -- 愈合
    774, -- 回春术
    33763, -- 生命绽放
    188550, -- 生命绽放
    48438, -- 野性成长
    102351, -- 塞纳里奥结界
    102352, -- 塞纳里奥结界
    391891, -- 激变蜂群

    -- evoker
    363502, -- 梦境飞行
    370889, -- 双生护卫
    364343, -- 回响
    355941, -- 梦境吐息
    376788, -- 梦境吐息（回响）
    366155, -- 逆转
    367364, -- 逆转（回响）
    373862, -- 时空畸体
    378001, -- 梦境投影（pvp）
    373267, -- 缚誓生命

    -- monk
    119611, -- 复苏之雾
    124682, -- 氤氲之雾
    191840, -- 精华之泉
    325209, -- 氤氲之息
    -- 386276, -- 骨尘酒
    -- 343737, -- 抚慰之息
    -- 387766, -- 滋养真气

    -- paladin
    53563, -- 圣光道标
    223306, -- 赋予信仰
    148039, -- 信仰屏障
    156910, -- 信仰道标
    200025, -- 美德道标
    287280, -- 圣光闪烁
    388013, -- 阳春祝福
    388007, -- 仲夏祝福
    388010, -- 暮秋祝福
    388011, -- 凛冬祝福
    200654, -- 提尔的拯救
    
    -- priest
    139, -- 恢复
    41635, -- 愈合祷言
    17, -- 真言术：盾
    194384, -- 救赎
    77489, -- 圣光回响
    372847, -- 光明之泉恢复
    
    -- shaman
    974, -- 大地之盾
    383648, -- 大地之盾（天赋）
    61295, -- 激流
    382024, -- 大地生命武器
}

function F:FirstRun()
    local icons = "\n\n"
    for i, id in pairs(spells) do
        local icon = select(3, GetSpellInfo(id))
        icons = icons .. "|T"..icon..":0|t"
        if i % 11 == 0 then
            icons = icons .. "\n"    
        end
    end

    local popup = Cell:CreateConfirmPopup(Cell.frames.anchorFrame, 200, L["Would you like Cell to create a \"Healers\" indicator (icons)?"]..icons, function(self)
        local currentLayoutTable = Cell.vars.currentLayoutTable

        local last = #currentLayoutTable["indicators"]
        if currentLayoutTable["indicators"][last]["type"] == "built-in" then
            indicatorName = "indicator"..(last+1)
        else
            indicatorName = "indicator"..(tonumber(strmatch(currentLayoutTable["indicators"][last]["indicatorName"], "%d+"))+1)
        end
        
        tinsert(currentLayoutTable["indicators"], {
            ["name"] = "Healers",
            ["indicatorName"] = indicatorName,
            ["type"] = "icons",
            ["enabled"] = true,
            ["position"] = {"TOPRIGHT", "TOPRIGHT", 0, 3},
            ["frameLevel"] = 5,
            ["size"] = {13, 13},
            ["num"] = 5,
            ["orientation"] = "right-to-left",
            ["font"] = {"Cell ".._G.DEFAULT, 11, "Outline", 2, 1},
            ["showDuration"] = false,
            ["auraType"] = "buff",
            ["castByMe"] = true,
            ["auras"] = spells,
        })
        Cell:Fire("UpdateIndicators", Cell.vars.currentLayout, indicatorName, "create", currentLayoutTable["indicators"][last+1])
        CellDB["firstRun"] = false
        F:ReloadIndicatorList()
    end, function()
        CellDB["firstRun"] = false
    end)
    popup:SetPoint("TOPLEFT")
    popup:Show()
end

-------------------------------------------------
-- cleuAuras
-------------------------------------------------
local cleuAuras = {}

-- local cleus = {}
-- for _, t in pairs(cleuAuras) do
--     local icon = select(3, GetSpellInfo(t[1]))
--     cleus[t[1]] = {t[2], icon}
-- end
-- cleuAuras = F:Copy(cleus)

function I:UpdateCleuAuras(t)
    -- reset
    wipe(cleuAuras)
    -- cleuAuras = F:Copy(cleus)
    -- insert
    for _, c in pairs(t) do
        local icon = select(3, GetSpellInfo(c[1]))
        cleuAuras[c[1]] = {c[2], icon}
    end
end
    
function I:CheckCleuAura(id)
    return cleuAuras[id]
end

-------------------------------------------------
-- targetedSpells
-------------------------------------------------
local targetedSpells = {
    -- Mists of Pandaria -----------
    -- 青龙寺
    106823, -- 翔龙猛袭
    106841, -- 青龙猛袭

    -- Legion ----------------------
    -- 群星庭院
    211473, -- 暗影鞭笞
    -- 英灵殿
    193092, -- 放血扫击
    193659, -- 邪炽冲刺
    192018, -- 光明之盾
    196838, -- 血之气息

    -- Shadowlands -----------------
    320788, -- 冻结之缚
    344496, -- 震荡爆发
    319941, -- 碎石之跃
    322614, -- 心灵连接
    320132, -- 暗影之怒
    334053, -- 净化冲击波
    320596, -- 深重呕吐
    356924, -- 屠戮
    356666, -- 刺骨之寒
    319713, -- 巨兽奔袭
    338606, -- 病态凝视
    343556, -- 病态凝视
    324079, -- 收割之镰
    317963, -- 知识烦扰
    333861, -- 回旋利刃
    332234, -- 挥发精油
    -- 328429, -- 窒息勒压

    -- Dragonflight ----------------
    -- 化身巨龙牢窟
    375870, -- 致死石爪
    395906, -- 电化之颌
    372158, -- 破甲一击
    372056, -- 碾压
    375580, -- 西风猛击
    376276, -- 震荡猛击

    -- 红玉新生法池
    372858, -- 灼热打击
    381512, -- 风暴猛击
    -- 奈萨鲁斯
    374533, -- 炽热挥舞
    377018, -- 熔火真金
    -- 蕨皮山谷
    381444, -- 野蛮冲撞
    373912, -- 腐朽打击
    -- 碧蓝魔馆
    374789, -- 注能打击
    372222, -- 奥术顺劈
    384978, -- 巨龙打击
    391136, -- 肩部猛击
    -- 诺库德阻击战
    376827, -- 传导打击
    376829, -- 雷霆打击
    375937, -- 撕裂猛击
    375929, -- 野蛮打击
    376644, -- 钢铁之矛
    376865, -- 静电之矛
    382836, -- 残杀
}

function I:GetDefaultTargetedSpellsList()
    return targetedSpells
end

function I:GetDefaultTargetedSpellsGlow()
    return {"Pixel", {0.95,0.95,0.32,1}, 9, 0.25, 8, 2}
end

-------------------------------------------------
-- Consumables: Healing Potion & Healthstone
-------------------------------------------------
local consumables = {
    {
        6262, -- 治疗石
        {"A", {0.4, 1, 0}},
    },
    {
        370511, -- 振奋治疗药水
        {"A", {1, 0.1, 0.1}},
    },
    {
        371024, -- 元素强能药水
        {"C3", {1, 1, 0}},
    },
    -- {
    --     359867, -- 宇宙治疗药水
    --     {"A", {1, 0.1, 0.1}},
    -- },
    -- {
    --     307192, -- 灵魂治疗药水
    --     {"A", {1, 0.1, 0.1}},
    -- },
}


function I:GetDefaultConsumables()
    return consumables
end

function I:ConvertConsumables(db)
    local temp = {}
    for _, t in pairs(db) do
        temp[t[1]] = t[2]
    end
    return temp
end

-------------------------------------------------
-- missing buffs
-------------------------------------------------
local missingBuffs = {
    21562, -- PWF
    1126, -- MotW
    1459, -- AB
    6673, -- BS
    364342, -- BotB
}

function I:GetDefaultMissingBuffs()
    return missingBuffs
end

function I:GetMissingBuffsString()
    local s = ""
    for _, id in pairs(missingBuffs) do
        local icon = select(3, GetSpellInfo(id))
        if icon then
            s = s .. "|T" .. icon .. ":14:14:0:0:14:14:1:13:1:13|t "
        end
    end
    return s
end