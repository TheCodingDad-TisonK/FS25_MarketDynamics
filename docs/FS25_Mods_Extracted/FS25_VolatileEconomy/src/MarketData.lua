-- MarketData.lua  v1.0
-- Volatile Economy — Author: NoticeGG
-- ±10% balance, 40 events including production goods

MarketData = {}
MarketData_mt = Class(MarketData)

-- ============================================================
-- TIMING
-- ============================================================
MarketData.TICK_INTERVAL_HOURS = 6
MarketData.EVENT_CHECK_INTERVAL_DAYS = 3
MarketData.GLOBAL_EVENT_COOLDOWN_DAYS = 8

-- ============================================================
-- ЦЕНОВОЙ ДИАПАЗОН  (±10%)
-- ============================================================
MarketData.MAX_PRICE_DEVIATION = 0.10
MarketData.PRICE_FLOOR = 0.90
MarketData.MONTHLY_TARGET_SPREAD = 0.05
MarketData.INTRAMONTH_DRIFT_SPEED = 0.08
MarketData.TICK_NOISE_AMPLITUDE = 0.004
MarketData.TREND_FLOOR = -0.006

-- ============================================================
-- СИСТЕМА КОНКУРЕНЦИИ
-- ============================================================
MarketData.COMPETITION_LURE_STRENGTH = 0.03
MarketData.NEGLECT_SCORE_PER_MONTH = 1.0
MarketData.MAX_LURE_BONUS = 0.04
MarketData.NEGLECT_DECAY_ON_SALE = 0.55

-- ============================================================
-- ШОК ПРЕДЛОЖЕНИЯ
-- ============================================================
MarketData.SUPPLY_SHOCK_FACTOR = 0.000015
MarketData.COMPETITOR_MIN_TONS = 0.1
MarketData.COMPETITOR_MAX_TONS = 2.0

-- ============================================================
-- СПЕЦИАЛЬНЫЕ МНОЖИТЕЛИ ТОВАРОВ
-- Применяются поверх базовой цены ПЕРЕД модификаторами мода
-- ============================================================
MarketData.FILL_TYPE_BASE_MULTIPLIERS = {
    cake = 2.0,   -- Торты продаются в 2 раза дороже
}

-- ============================================================
-- СЕЗОННЫЙ СПРОС
-- ============================================================
MarketData.SEASONAL_DEMAND = {
    [1] = { -- Весна
        wheat = 0.96, barley = 0.96, canola = 1.04, corn = 0.94, sunflower = 0.98,
        soybean = 0.97, potato = 1.02, sugarbeet = 0.96, grass_windrow = 0.97,
        silage = 0.98, liquidManure = 0.94, manure = 0.94, woodChips = 0.96,
        flour = 0.98, bread = 1.02, cake = 1.04, butter = 1.02, cheese = 1.0,
        sugar = 0.98, chocolate = 1.02, clothes = 1.04, fabric = 1.02,
        furniture = 1.04, boards = 1.02, prefabWalls = 1.02, oil = 0.98,
    },
    [2] = { -- Лето
        wheat = 1.06, barley = 1.04, canola = 0.97, corn = 1.03, sunflower = 1.06,
        soybean = 1.03, potato = 0.97, sugarbeet = 0.97, grass_windrow = 1.04,
        silage = 0.97, liquidManure = 0.97, manure = 0.97, woodChips = 0.94,
        flour = 1.02, bread = 0.98, cake = 0.97, butter = 0.98, cheese = 0.98,
        sugar = 1.02, chocolate = 0.96, clothes = 0.98, fabric = 0.98,
        furniture = 0.98, boards = 1.04, prefabWalls = 1.04, oil = 1.02,
    },
    [3] = { -- Осень
        wheat = 0.98, barley = 0.97, canola = 1.02, corn = 1.06, sunflower = 1.02,
        soybean = 1.06, potato = 1.04, sugarbeet = 1.06, grass_windrow = 0.96,
        silage = 1.04, liquidManure = 1.02, manure = 1.02, woodChips = 1.03,
        flour = 1.04, bread = 1.04, cake = 1.06, butter = 1.04, cheese = 1.04,
        sugar = 1.04, chocolate = 1.06, clothes = 1.06, fabric = 1.04,
        furniture = 1.06, boards = 1.02, prefabWalls = 1.02, oil = 1.02,
    },
    [4] = { -- Зима
        wheat = 1.03, barley = 1.02, canola = 1.02, corn = 0.97, sunflower = 0.96,
        soybean = 0.94, potato = 1.06, sugarbeet = 1.04, grass_windrow = 0.94,
        silage = 1.06, liquidManure = 1.04, manure = 1.04, woodChips = 1.06,
        flour = 1.04, bread = 1.06, cake = 1.08, butter = 1.06, cheese = 1.06,
        sugar = 1.06, chocolate = 1.08, clothes = 1.08, fabric = 1.06,
        furniture = 1.02, boards = 0.96, prefabWalls = 0.96, oil = 1.0,
    },
}

-- ============================================================
-- РЫНОЧНЫЕ СОБЫТИЯ — 42 события (±10% баланс)
--
-- ПРАВИЛА:
--   Позитивные: 1.05 – 1.10 (нишевые до 1.12)
--   Негативные: 0.90 – 0.95 (нишевые до 0.88)
--   Глобальные (all): 0.94 – 1.06
-- ============================================================
MarketData.EVENTS = {

    -- ══════════════════════════════════════════════════════
    -- ПОЗИТИВНЫЕ — СЫРЬЁ
    -- ══════════════════════════════════════════════════════

    {
        id = "eksportny_bum", title = "Экспортный бум",
        desc = "Зарубежные трейдеры скупают зерно вагонами. Местные элеваторы подняли ставки.",
        fillTypes = {"wheat", "barley", "corn", "canola"},
        durationDays = 7, multiplier = 1.07, weight = 10, isNegative = false, isGlobal = false,
        seasons = {1,2,3},
    },
    {
        id = "zasukha_v_regione", title = "Засуха в регионе",
        desc = "Соседние районы сгорели на корню. Покупатели платят премию за любое зерно.",
        fillTypes = {"wheat", "barley", "canola", "corn", "soybean"},
        durationDays = 12, multiplier = 1.09, weight = 6, isNegative = false, isGlobal = false,
        seasons = {2},
    },
    {
        id = "toplivny_krizis", title = "Топливный кризис",
        desc = "Цены на дизель взлетели. Покупатели переплачивают, лишь бы не гонять грузовики далеко.",
        fillTypes = {"all"},
        durationDays = 5, multiplier = 1.06, weight = 8, isNegative = false, isGlobal = true,
        seasons = {3,4},
    },
    {
        id = "morozny_udar", title = "Морозный удар",
        desc = "Поздние заморозки выкосили картофель и свёклу в трёх районах.",
        fillTypes = {"potato", "sugarbeet"},
        durationDays = 10, multiplier = 1.12, weight = 5, isNegative = false, isGlobal = false,
        seasons = {1,4},
    },
    {
        id = "biogaz_zakon", title = "Закон о биогазе",
        desc = "Правительство перевело электростанции на биотопливо. Масличные стали стратегическим сырьём.",
        fillTypes = {"canola", "sunflower", "corn"},
        durationDays = 12, multiplier = 1.09, weight = 7, isNegative = false, isGlobal = false,
        seasons = {1,2,3,4},
    },
    {
        id = "torgi_za_urozhay", title = "Торги за урожай",
        desc = "Два агрохолдинга устроили аукцион за местное сырьё. У вас сильная позиция.",
        fillTypes = {"all"},
        durationDays = 6, multiplier = 1.06, weight = 5, isNegative = false, isGlobal = true,
        seasons = {2,3},
    },
    {
        id = "stadion_v_gorode", title = "Чемпионат и пивной ажиотаж",
        desc = "В городе чемпионат, пивзаводы работают в три смены. Ячмень разлетается.",
        fillTypes = {"barley"},
        durationDays = 9, multiplier = 1.10, weight = 4, isNegative = false, isGlobal = false,
        seasons = {2,3},
    },
    {
        id = "vegansky_trend", title = "Веганский бум",
        desc = "Соя и подсолнечник — новая нефть. Переработчики в очереди.",
        fillTypes = {"soybean", "sunflower"},
        durationDays = 11, multiplier = 1.09, weight = 5, isNegative = false, isGlobal = false,
        seasons = {1,2,3,4},
    },
    {
        id = "holodnaya_zima", title = "Суровая зима",
        desc = "Рекордные морозы. Животноводы сметают силос и сено — запасаются впрок.",
        fillTypes = {"silage", "grass_windrow"},
        durationDays = 13, multiplier = 1.09, weight = 6, isNegative = false, isGlobal = false,
        seasons = {3,4},
    },
    {
        id = "novaya_ferma_zakrylas", title = "Конкурент разорился",
        desc = "Крупное хозяйство обанкротилось. Покупатели срочно ищут новых поставщиков.",
        fillTypes = {"wheat", "barley", "corn", "potato"},
        durationDays = 8, multiplier = 1.07, weight = 4, isNegative = false, isGlobal = false,
        seasons = {1,2,3,4},
    },
    {
        id = "navodneniye", title = "Наводнение на юге",
        desc = "Паводок затопил поля в южных районах. Покупатели разворачиваются в вашу сторону.",
        fillTypes = {"corn", "soybean", "sugarbeet"},
        durationDays = 10, multiplier = 1.09, weight = 5, isNegative = false, isGlobal = false,
        seasons = {1,2},
    },
    {
        id = "urozhay_provalen", title = "Провальный урожай у соседей",
        desc = "Эпидемия грибка уничтожила пшеницу в трёх районах. Мукомольни ищут поставщиков.",
        fillTypes = {"wheat", "barley"},
        durationDays = 14, multiplier = 1.10, weight = 4, isNegative = false, isGlobal = false,
        seasons = {2,3},
    },
    {
        id = "drevesnaya_goryachka", title = "Деревянная лихорадка",
        desc = "Газ снова пробил потолок. Все переходят на щепу — лесопилки завалены заказами.",
        fillTypes = {"woodChips"},
        durationDays = 10, multiplier = 1.12, weight = 4, isNegative = false, isGlobal = false,
        seasons = {3,4},
    },
    {
        id = "organika_moda", title = "Органика в моде",
        desc = "Супермаркеты переходят на органику. Натуральное удобрение стало ценным товаром.",
        fillTypes = {"manure", "liquidManure"},
        durationDays = 12, multiplier = 1.10, weight = 3, isNegative = false, isGlobal = false,
        seasons = {1,2,3},
    },

    -- ══════════════════════════════════════════════════════
    -- ПОЗИТИВНЫЕ — ПРОДУКЦИЯ ПРОИЗВОДСТВ
    -- ══════════════════════════════════════════════════════

    {
        id = "prazdnichny_sezon", title = "Праздничный сезон",
        desc = "Рождество и Новый год. Торты, шоколад и выпечка расходятся мгновенно.",
        fillTypes = {"cake", "chocolate", "bread", "flour", "sugar"},
        durationDays = 10, multiplier = 1.10, weight = 7, isNegative = false, isGlobal = false,
        seasons = {4},
    },
    {
        id = "stroitelny_bum", title = "Строительный бум",
        desc = "Государственная программа жилья. Доски, стены и мебель — нарасхват.",
        fillTypes = {"boards", "prefabWalls", "furniture"},
        durationDays = 14, multiplier = 1.10, weight = 6, isNegative = false, isGlobal = false,
        seasons = {1,2,3},
    },
    {
        id = "restoranny_trend", title = "Ресторанный бум",
        desc = "Волна новых ресторанов по всему региону. Масло, сыр и мука улетают со склада.",
        fillTypes = {"butter", "cheese", "flour", "oil"},
        durationDays = 10, multiplier = 1.09, weight = 5, isNegative = false, isGlobal = false,
        seasons = {2,3},
    },
    {
        id = "modnaya_odezhda", title = "Неделя моды",
        desc = "Международная выставка подогрела спрос на ткани и одежду.",
        fillTypes = {"clothes", "fabric"},
        durationDays = 8, multiplier = 1.10, weight = 4, isNegative = false, isGlobal = false,
        seasons = {1,3},
    },
    {
        id = "svadebny_sezon", title = "Свадебный сезон",
        desc = "Лето — пик свадеб. Кондитерские работают без выходных, торты на вес золота.",
        fillTypes = {"cake", "chocolate", "sugar", "flour"},
        durationDays = 12, multiplier = 1.10, weight = 5, isNegative = false, isGlobal = false,
        seasons = {2},
    },
    {
        id = "shkoly_remontiruyut", title = "Ремонт школ и больниц",
        desc = "Госзаказ на мебель для бюджетных учреждений. Столярные мастерские загружены.",
        fillTypes = {"furniture", "boards"},
        durationDays = 10, multiplier = 1.09, weight = 4, isNegative = false, isGlobal = false,
        seasons = {2,3},
    },
    {
        id = "masloboy_defitsit", title = "Дефицит масла",
        desc = "Импортное масло застряло на таможне. Местное масло и подсолнечник выросли в цене.",
        fillTypes = {"oil", "sunflower", "canola"},
        durationDays = 8, multiplier = 1.08, weight = 5, isNegative = false, isGlobal = false,
        seasons = {1,2,3,4},
    },

    -- ══════════════════════════════════════════════════════
    -- НЕГАТИВНЫЕ — СЫРЬЁ
    -- ══════════════════════════════════════════════════════

    {
        id = "perepolnen_rynok", title = "Рынок переполнен",
        desc = "Агрохолдинги одновременно вышли на продажу. Элеваторы забиты — цены падают.",
        fillTypes = {"wheat", "barley", "corn"},
        durationDays = 8, multiplier = 0.92, weight = 10, isNegative = true, isGlobal = false,
        seasons = {2,3},
    },
    {
        id = "importny_potop", title = "Импортный потоп",
        desc = "Дешёвый импорт захлестнул масличный сегмент.",
        fillTypes = {"soybean", "sunflower", "canola"},
        durationDays = 10, multiplier = 0.92, weight = 8, isNegative = true, isGlobal = false,
        seasons = {1,2,3,4},
    },
    {
        id = "ekonomichesky_krizis", title = "Экономический кризис",
        desc = "Банки повысили ставки, спрос просел по всему спектру.",
        fillTypes = {"all"},
        durationDays = 12, multiplier = 0.94, weight = 4, isNegative = true, isGlobal = true,
        seasons = {1,2,3,4},
    },
    {
        id = "rekordny_urozhay", title = "Рекордный урожай везде",
        desc = "Небывалый год для всей страны. Каждый амбар ломится — покупатели диктуют условия.",
        fillTypes = {"wheat", "barley", "corn", "canola", "soybean"},
        durationDays = 10, multiplier = 0.92, weight = 7, isNegative = true, isGlobal = false,
        seasons = {2,3},
    },
    {
        id = "zabastovka_voditelei", title = "Забастовка дальнобойщиков",
        desc = "Грузовики встали на трассах. Покупатели снизили лимиты.",
        fillTypes = {"all"},
        durationDays = 4, multiplier = 0.95, weight = 6, isNegative = true, isGlobal = true,
        seasons = {1,2,3,4},
    },
    {
        id = "cenovaya_voyna", title = "Ценовая война заводов",
        desc = "Два завода так яростно сбивали друг другу цену, что обвалили весь рынок.",
        fillTypes = {"all"},
        durationDays = 5, multiplier = 0.94, weight = 4, isNegative = true, isGlobal = true,
        seasons = {1,2,3,4},
    },
    {
        id = "skandal_kachestvo", title = "Скандал с качеством",
        desc = "СМИ раструбили о заражённой партии зерна. Покупатели занижают цены.",
        fillTypes = {"wheat", "barley", "corn"},
        durationDays = 7, multiplier = 0.94, weight = 5, isNegative = true, isGlobal = false,
        seasons = {2,3},
    },
    {
        id = "novye_sklady", title = "Новый логистический хаб",
        desc = "Конкуренты открыли огромный склад в 50 км. Местные точки потеряли покупателей.",
        fillTypes = {"wheat", "barley", "canola", "corn"},
        durationDays = 18, multiplier = 0.94, weight = 4, isNegative = true, isGlobal = false,
        seasons = {1,2,3,4},
    },
    {
        id = "zhara_padenie_silosa", title = "Жара убивает силос",
        desc = "Аномальная жара снизила питательность зелёной массы.",
        fillTypes = {"silage", "grass_windrow"},
        durationDays = 9, multiplier = 0.92, weight = 5, isNegative = true, isGlobal = false,
        seasons = {2},
    },
    {
        id = "dieta_trend", title = "Мода на безуглеводную диету",
        desc = "Блогеры объявили картофель врагом. Переработчики жалуются на затоваривание.",
        fillTypes = {"potato", "sugarbeet"},
        durationDays = 10, multiplier = 0.92, weight = 4, isNegative = true, isGlobal = false,
        seasons = {1,2,3,4},
    },
    {
        id = "gazovaya_konkurenciya", title = "Дешёвый газ вернулся",
        desc = "Цены на газ рухнули. Щепа и биотопливо никому не нужны.",
        fillTypes = {"woodChips"},
        durationDays = 12, multiplier = 0.88, weight = 4, isNegative = true, isGlobal = false,
        seasons = {1,2},
    },
    {
        id = "fitosanitarny_zapret", title = "Фитосанитарный запрет",
        desc = "Карантинная служба запретила вывоз сои и подсолнечника за пределы района.",
        fillTypes = {"soybean", "sunflower"},
        durationDays = 8, multiplier = 0.92, weight = 4, isNegative = true, isGlobal = false,
        seasons = {2,3},
    },
    {
        id = "zavod_na_remont", title = "Завод встал на ремонт",
        desc = "Маслозавод закрылся на ТО. Мощностей для переработки масличных почти нет.",
        fillTypes = {"canola", "sunflower", "soybean"},
        durationDays = 10, multiplier = 0.92, weight = 5, isNegative = true, isGlobal = false,
        seasons = {1,2,3,4},
    },
    {
        id = "perenasyschennost_udobreniy", title = "Удобрений некуда девать",
        desc = "Животноводство в регионе сократилось. Навоза больше, чем покупателей.",
        fillTypes = {"manure", "liquidManure"},
        durationDays = 12, multiplier = 0.90, weight = 3, isNegative = true, isGlobal = false,
        seasons = {1,2,3,4},
    },

    -- ══════════════════════════════════════════════════════
    -- НЕГАТИВНЫЕ — ПРОДУКЦИЯ ПРОИЗВОДСТВ
    -- ══════════════════════════════════════════════════════

    {
        id = "stagnatsiya_stroyki", title = "Стройки встали",
        desc = "Заморозка госконтрактов. Мебель, доски и стеновые панели никому не нужны.",
        fillTypes = {"furniture", "boards", "prefabWalls"},
        durationDays = 14, multiplier = 0.91, weight = 5, isNegative = true, isGlobal = false,
        seasons = {4,1},
    },
    {
        id = "sahar_import", title = "Сахарный демпинг",
        desc = "Бразильский сахар заполнил прилавки. Местные кондитерские снижают закупки.",
        fillTypes = {"sugar", "chocolate", "cake"},
        durationDays = 10, multiplier = 0.92, weight = 5, isNegative = true, isGlobal = false,
        seasons = {1,2,3,4},
    },
    {
        id = "moda_proshla", title = "Антимода на хендмейд",
        desc = "Тренд на масс-маркет. Кустарная одежда и ткани резко потеряли спрос.",
        fillTypes = {"clothes", "fabric"},
        durationDays = 8, multiplier = 0.91, weight = 4, isNegative = true, isGlobal = false,
        seasons = {2,4},
    },
    {
        id = "maslo_perenasos", title = "Масло девать некуда",
        desc = "Перепроизводство растительного масла. Экспорт заблокирован, склады полные.",
        fillTypes = {"oil", "butter"},
        durationDays = 10, multiplier = 0.91, weight = 4, isNegative = true, isGlobal = false,
        seasons = {2,3},
    },
    {
        id = "dietologiya_udar", title = "Врачи против сладкого",
        desc = "Минздрав запустил кампанию. Продажи тортов и шоколада резко упали.",
        fillTypes = {"cake", "chocolate", "sugar"},
        durationDays = 10, multiplier = 0.90, weight = 4, isNegative = true, isGlobal = false,
        seasons = {1,2},
    },
}

-- ============================================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================================

function MarketData.buildEventPool()
    local pool = {}
    for _, event in ipairs(MarketData.EVENTS) do
        for _ = 1, event.weight do
            table.insert(pool, event)
        end
    end
    return pool
end

function MarketData.buildGlobalEventIds()
    local ids = {}
    for _, event in ipairs(MarketData.EVENTS) do
        if event.isGlobal then ids[event.id] = true end
    end
    return ids
end

return MarketData
