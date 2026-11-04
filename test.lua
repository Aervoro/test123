-- Original reference-matched UI. Put this entire file in a LocalScript.
-- StarterPlayer > StarterPlayerScripts. Demo controls only; no aim/ESP logic.
local KEY_URL = 'https://raw.githubusercontent.com/Aervoro/test123/refs/heads/main/key.txt'
local DISCORD_URL = '' -- Put your https://discord.gg/... invite here.
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local MarketplaceService = game:GetService('MarketplaceService')
-- Optional strict place ID override; zero accepts a place with the exact game title.
local TARGET_PLACE_ID = 0
if not game:IsLoaded() then game.Loaded:Wait() end
local permitted = TARGET_PLACE_ID>0 and game.PlaceId==TARGET_PLACE_ID
if TARGET_PLACE_ID==0 then
    local ok,info=pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId,Enum.InfoType.Asset) end)
    permitted=ok and type(info)=='table' and string.upper(info.Name or '')=='REALISTIC HOME DEFENSE'
end
if not permitted then warn('[Fanta] This UI only supports REALISTIC HOME DEFENSE.'); return end
local player = Players.LocalPlayer
local Library = {}
local currentLanguage='English'
local Translations={
    ['English']={},
    ['Español']={['Aim']='Puntería',['Silent Aim']='Puntería silenciosa',['Team check']='Comprobar equipo',['Prediction']='Predicción',['Show FOV']='Mostrar FOV',['FOV colour']='Color del FOV',['Target part']='Parte objetivo',['Head']='Cabeza',['Torso']='Torso',['FOV radius']='Radio del FOV',['Max distance']='Distancia máxima',['Shoot through walls (Disabled)']='Disparar paredes (Desactivado)',['Shoot through walls']='Disparar a través de paredes',['Max thickness']='Grosor máximo',['Max surfaces']='Superficies máximas',['DISABLED']='DESACTIVADO',['Gun Mods']='Armas',['Settings']='Ajustes',['Theme']='Tema',['Halloween']='Halloween',['Christmas']='Navidad',['Language']='Idioma',['Interface']='Interfaz',['Home: show / hide']='Home: mostrar / ocultar',['Unload']='Descargar',['Always']='Siempre',['Toggle']='Alternar',['Hold']='Mantener',['Clear']='Borrar',['None']='Ninguno',['Search...']='Buscar...'},
    ['Français']={['Aim']='Visée',['Silent Aim']='Visée silencieuse',['Team check']='Vérifier équipe',['Prediction']='Prédiction',['Show FOV']='Afficher FOV',['FOV colour']='Couleur du FOV',['Target part']='Partie ciblée',['Head']='Tête',['Torso']='Torse',['FOV radius']='Rayon du FOV',['Max distance']='Distance maximale',['Shoot through walls (Disabled)']='Tir à travers murs (Désactivé)',['Shoot through walls']='Tir à travers les murs',['Max thickness']='Épaisseur maximale',['Max surfaces']='Surfaces maximales',['DISABLED']='DÉSACTIVÉ',['Gun Mods']='Armes',['Settings']='Paramètres',['Theme']='Thème',['Christmas']='Noël',['Language']='Langue',['Interface']='Interface',['Home: show / hide']='Home: afficher / masquer',['Unload']='Décharger',['Always']='Toujours',['Toggle']='Basculer',['Hold']='Maintenir',['Clear']='Effacer',['None']='Aucun',['Search...']='Rechercher...'},
    ['Deutsch']={['Aim']='Zielen',['Silent Aim']='Stilles Zielen',['Team check']='Team prüfen',['Prediction']='Vorhersage',['Show FOV']='FOV anzeigen',['FOV colour']='FOV-Farbe',['Target part']='Zielteil',['Head']='Kopf',['Torso']='Oberkörper',['FOV radius']='FOV-Radius',['Max distance']='Max. Entfernung',['Shoot through walls (Disabled)']='Durch Wände (Deaktiviert)',['Shoot through walls']='Durch Wände schießen',['Max thickness']='Max. Dicke',['Max surfaces']='Max. Oberflächen',['DISABLED']='DEAKTIVIERT',['Gun Mods']='Waffen',['Settings']='Einstellungen',['Theme']='Design',['Christmas']='Weihnachten',['Language']='Sprache',['Interface']='Oberfläche',['Home: show / hide']='Home: anzeigen / ausblenden',['Unload']='Entladen',['Always']='Immer',['Toggle']='Umschalten',['Hold']='Halten',['Clear']='Löschen',['None']='Keine',['Search...']='Suchen...'},
    ['Português']={['Aim']='Mira',['Silent Aim']='Mira silenciosa',['Team check']='Verificar equipe',['Prediction']='Previsão',['Show FOV']='Mostrar FOV',['FOV colour']='Cor do FOV',['Target part']='Parte do alvo',['Head']='Cabeça',['Torso']='Tronco',['FOV radius']='Raio do FOV',['Max distance']='Distância máxima',['Shoot through walls (Disabled)']='Atirar por paredes (Desativado)',['Shoot through walls']='Atirar através de paredes',['Max thickness']='Espessura máxima',['Max surfaces']='Superfícies máximas',['DISABLED']='DESATIVADO',['Gun Mods']='Armas',['Settings']='Configurações',['Theme']='Tema',['Christmas']='Natal',['Language']='Idioma',['Interface']='Interface',['Home: show / hide']='Home: mostrar / ocultar',['Unload']='Descarregar',['Always']='Sempre',['Toggle']='Alternar',['Hold']='Segurar',['Clear']='Limpar',['None']='Nenhum',['Search...']='Pesquisar...'},
    ['Polski']={['Aim']='Celowanie',['Silent Aim']='Ciche celowanie',['Team check']='Sprawdzaj drużynę',['Prediction']='Przewidywanie',['Show FOV']='Pokaż FOV',['FOV colour']='Kolor FOV',['Target part']='Część celu',['Head']='Głowa',['Torso']='Tułów',['FOV radius']='Promień FOV',['Max distance']='Maks. odległość',['Shoot through walls (Disabled)']='Przez ściany (Wyłączone)',['Shoot through walls']='Strzelanie przez ściany',['Max thickness']='Maks. grubość',['Max surfaces']='Maks. powierzchnie',['DISABLED']='WYŁĄCZONE',['Gun Mods']='Broń',['Settings']='Ustawienia',['Theme']='Motyw',['Christmas']='Boże Narodzenie',['Language']='Język',['Interface']='Interfejs',['Home: show / hide']='Home: pokaż / ukryj',['Unload']='Wyłącz',['Always']='Zawsze',['Toggle']='Przełączaj',['Hold']='Przytrzymaj',['Clear']='Wyczyść',['None']='Brak',['Search...']='Szukaj...'},
}
-- Built-in packs for every language in Roblox localization tables.
local ExtraTranslations={
    ["Shqip (Albanian)"]={["Aim"]="Synimi",["Silent Aim"]="Synim i heshtur",["Team check"]="Kontroll ekipi",["Prediction"]="Parashikim",["Show FOV"]="Shfaq FOV",["FOV colour"]="Ngjyra FOV",["Target part"]="Pjesa e synuar",["Head"]="Koka",["Torso"]="Trupi",["FOV radius"]="Rrezja FOV",["Max distance"]="Distanca maksimale",["Shoot through walls"]="Qëllo përmes mureve",["Max thickness"]="Trashësia maksimale",["Max surfaces"]="Sipërfaqet maksimale",["DISABLED"]="ÇAKTIVIZUAR",["Gun Mods"]="Armët",["Settings"]="Cilësimet",["Theme"]="Tema",["Language"]="Gjuha",["Interface"]="Ndërfaqja",["Unload"]="Çngarko",["Always"]="Gjithmonë",["Toggle"]="Ndërro",["Hold"]="Mbaj",["Clear"]="Pastro",["Search..."]="Kërko...",["Config"]="Konfigurimi",["Name"]="Emri",["Saved"]="Të ruajtura",["Save"]="Ruaj",["Load"]="Ngarko",["Delete"]="Fshi",["Refresh"]="Rifresko",["Home: show / hide"]="Home: shfaq / fshih"},
    ["العربية (Arabic)"]={["Aim"]="التصويب",["Silent Aim"]="التصويب الصامت",["Team check"]="فحص الفريق",["Prediction"]="التنبؤ",["Show FOV"]="إظهار FOV",["FOV colour"]="لون FOV",["Target part"]="الجزء المستهدف",["Head"]="الرأس",["Torso"]="الجذع",["FOV radius"]="نصف قطر FOV",["Max distance"]="أقصى مسافة",["Shoot through walls"]="إطلاق عبر الجدران",["Max thickness"]="أقصى سماكة",["Max surfaces"]="أقصى عدد أسطح",["DISABLED"]="معطل",["Gun Mods"]="الأسلحة",["Settings"]="الإعدادات",["Theme"]="السمة",["Language"]="اللغة",["Interface"]="الواجهة",["Unload"]="إلغاء التحميل",["Always"]="دائماً",["Toggle"]="تبديل",["Hold"]="ضغط مستمر",["Clear"]="مسح",["Search..."]="بحث...",["Config"]="التكوين",["Name"]="الاسم",["Saved"]="المحفوظة",["Save"]="حفظ",["Load"]="تحميل",["Delete"]="حذف",["Refresh"]="تحديث",["Home: show / hide"]="Home: إظهار / إخفاء"},
    ["বাংলা (Bengali)"]={["Aim"]="নিশানা",["Silent Aim"]="নীরব নিশানা",["Team check"]="দল পরীক্ষা",["Prediction"]="পূর্বাভাস",["Show FOV"]="FOV দেখান",["FOV colour"]="FOV রং",["Target part"]="লক্ষ্যের অংশ",["Head"]="মাথা",["Torso"]="ধড়",["FOV radius"]="FOV ব্যাসার্ধ",["Max distance"]="সর্বোচ্চ দূরত্ব",["Shoot through walls"]="দেয়াল ভেদ করে গুলি",["Max thickness"]="সর্বোচ্চ পুরুত্ব",["Max surfaces"]="সর্বোচ্চ পৃষ্ঠ",["DISABLED"]="নিষ্ক্রিয়",["Gun Mods"]="অস্ত্র",["Settings"]="সেটিংস",["Theme"]="থিম",["Language"]="ভাষা",["Interface"]="ইন্টারফেস",["Unload"]="আনলোড",["Always"]="সর্বদা",["Toggle"]="বদলান",["Hold"]="ধরে রাখুন",["Clear"]="মুছুন",["Search..."]="খুঁজুন...",["Config"]="কনফিগ",["Name"]="নাম",["Saved"]="সংরক্ষিত",["Save"]="সংরক্ষণ",["Load"]="লোড",["Delete"]="মুছুন",["Refresh"]="রিফ্রেশ",["Home: show / hide"]="Home: দেখান / লুকান"},
    ["Norsk bokmål (Norwegian)"]={["Aim"]="Sikting",["Silent Aim"]="Stille sikting",["Team check"]="Lagsjekk",["Prediction"]="Prediksjon",["Show FOV"]="Vis FOV",["FOV colour"]="FOV-farge",["Target part"]="Måldel",["Head"]="Hode",["Torso"]="Overkropp",["FOV radius"]="FOV-radius",["Max distance"]="Maks avstand",["Shoot through walls"]="Skyt gjennom vegger",["Max thickness"]="Maks tykkelse",["Max surfaces"]="Maks flater",["DISABLED"]="DEAKTIVERT",["Gun Mods"]="Våpen",["Settings"]="Innstillinger",["Theme"]="Tema",["Language"]="Språk",["Interface"]="Grensesnitt",["Unload"]="Last ut",["Always"]="Alltid",["Toggle"]="Veksle",["Hold"]="Hold",["Clear"]="Fjern",["Search..."]="Søk...",["Config"]="Oppsett",["Name"]="Navn",["Saved"]="Lagrede",["Save"]="Lagre",["Load"]="Last",["Delete"]="Slett",["Refresh"]="Oppdater",["Home: show / hide"]="Home: vis / skjul"},
    ["Bosanski (Bosnian)"]={["Aim"]="Ciljanje",["Silent Aim"]="Tiho ciljanje",["Team check"]="Provjera tima",["Prediction"]="Predviđanje",["Show FOV"]="Prikaži FOV",["FOV colour"]="Boja FOV",["Target part"]="Dio mete",["Head"]="Glava",["Torso"]="Trup",["FOV radius"]="Radijus FOV",["Max distance"]="Maks. udaljenost",["Shoot through walls"]="Pucanje kroz zidove",["Max thickness"]="Maks. debljina",["Max surfaces"]="Maks. površine",["DISABLED"]="ISKLJUČENO",["Gun Mods"]="Oružje",["Settings"]="Postavke",["Theme"]="Tema",["Language"]="Jezik",["Interface"]="Sučelje",["Unload"]="Ukloni",["Always"]="Uvijek",["Toggle"]="Prebaci",["Hold"]="Drži",["Clear"]="Očisti",["Search..."]="Pretraži...",["Config"]="Konfiguracija",["Name"]="Ime",["Saved"]="Sačuvano",["Save"]="Sačuvaj",["Load"]="Učitaj",["Delete"]="Izbriši",["Refresh"]="Osvježi",["Home: show / hide"]="Home: prikaži / sakrij"},
    ["Български (Bulgarian)"]={["Aim"]="Прицелване",["Silent Aim"]="Тихо прицелване",["Team check"]="Проверка на отбора",["Prediction"]="Предвиждане",["Show FOV"]="Покажи FOV",["FOV colour"]="Цвят на FOV",["Target part"]="Целева част",["Head"]="Глава",["Torso"]="Торс",["FOV radius"]="Радиус на FOV",["Max distance"]="Макс. разстояние",["Shoot through walls"]="Стрелба през стени",["Max thickness"]="Макс. дебелина",["Max surfaces"]="Макс. повърхности",["DISABLED"]="ИЗКЛЮЧЕНО",["Gun Mods"]="Оръжия",["Settings"]="Настройки",["Theme"]="Тема",["Language"]="Език",["Interface"]="Интерфейс",["Unload"]="Разтовари",["Always"]="Винаги",["Toggle"]="Превключи",["Hold"]="Задръж",["Clear"]="Изчисти",["Search..."]="Търси...",["Config"]="Конфигурация",["Name"]="Име",["Saved"]="Запазени",["Save"]="Запази",["Load"]="Зареди",["Delete"]="Изтрий",["Refresh"]="Обнови",["Home: show / hide"]="Home: покажи / скрий"},
    ["မြန်မာ (Burmese)"]={["Aim"]="ချိန်ရွယ်မှု",["Silent Aim"]="အသံတိတ်ချိန်ရွယ်မှု",["Team check"]="အသင်းစစ်ဆေးမှု",["Prediction"]="ခန့်မှန်းမှု",["Show FOV"]="FOV ပြရန်",["FOV colour"]="FOV အရောင်",["Target part"]="ပစ်မှတ်အစိတ်အပိုင်း",["Head"]="ခေါင်း",["Torso"]="ကိုယ်ထည်",["FOV radius"]="FOV အချင်းဝက်",["Max distance"]="အများဆုံးအကွာအဝေး",["Shoot through walls"]="နံရံဖောက်ပစ်ရန်",["Max thickness"]="အများဆုံးအထူ",["Max surfaces"]="အများဆုံးမျက်နှာပြင်",["DISABLED"]="ပိတ်ထားသည်",["Gun Mods"]="လက်နက်များ",["Settings"]="ဆက်တင်များ",["Theme"]="အပြင်အဆင်",["Language"]="ဘာသာစကား",["Interface"]="မျက်နှာပြင်",["Unload"]="ပိတ်ရန်",["Always"]="အမြဲတမ်း",["Toggle"]="ပြောင်းရန်",["Hold"]="ဖိထားရန်",["Clear"]="ရှင်းရန်",["Search..."]="ရှာရန်...",["Config"]="သတ်မှတ်ချက်",["Name"]="အမည်",["Saved"]="သိမ်းထားသော",["Save"]="သိမ်းရန်",["Load"]="ဖွင့်ရန်",["Delete"]="ဖျက်ရန်",["Refresh"]="ပြန်တင်ရန်",["Home: show / hide"]="Home: ပြရန် / ဖျောက်ရန်"},
    ["简体中文 (Chinese Simplified)"]={["Aim"]="瞄准",["Silent Aim"]="静默瞄准",["Team check"]="队伍检查",["Prediction"]="预判",["Show FOV"]="显示 FOV",["FOV colour"]="FOV 颜色",["Target part"]="目标部位",["Head"]="头部",["Torso"]="躯干",["FOV radius"]="FOV 半径",["Max distance"]="最大距离",["Shoot through walls"]="穿墙射击",["Max thickness"]="最大厚度",["Max surfaces"]="最大表面数",["DISABLED"]="已禁用",["Gun Mods"]="武器",["Settings"]="设置",["Theme"]="主题",["Language"]="语言",["Interface"]="界面",["Unload"]="卸载",["Always"]="始终",["Toggle"]="切换",["Hold"]="按住",["Clear"]="清除",["Search..."]="搜索...",["Config"]="配置",["Name"]="名称",["Saved"]="已保存",["Save"]="保存",["Load"]="加载",["Delete"]="删除",["Refresh"]="刷新",["Home: show / hide"]="Home: 显示 / 隐藏"},
    ["繁體中文 (Chinese Traditional)"]={["Aim"]="瞄準",["Silent Aim"]="靜默瞄準",["Team check"]="隊伍檢查",["Prediction"]="預判",["Show FOV"]="顯示 FOV",["FOV colour"]="FOV 顏色",["Target part"]="目標部位",["Head"]="頭部",["Torso"]="軀幹",["FOV radius"]="FOV 半徑",["Max distance"]="最大距離",["Shoot through walls"]="穿牆射擊",["Max thickness"]="最大厚度",["Max surfaces"]="最大表面數",["DISABLED"]="已停用",["Gun Mods"]="武器",["Settings"]="設定",["Theme"]="主題",["Language"]="語言",["Interface"]="介面",["Unload"]="卸載",["Always"]="始終",["Toggle"]="切換",["Hold"]="按住",["Clear"]="清除",["Search..."]="搜尋...",["Config"]="配置",["Name"]="名稱",["Saved"]="已儲存",["Save"]="儲存",["Load"]="載入",["Delete"]="刪除",["Refresh"]="重新整理",["Home: show / hide"]="Home: 顯示 / 隱藏"},
    ["Hrvatski (Croatian)"]={["Aim"]="Ciljanje",["Silent Aim"]="Tiho ciljanje",["Team check"]="Provjera tima",["Prediction"]="Predviđanje",["Show FOV"]="Prikaži FOV",["FOV colour"]="Boja FOV",["Target part"]="Dio mete",["Head"]="Glava",["Torso"]="Trup",["FOV radius"]="Polumjer FOV",["Max distance"]="Maks. udaljenost",["Shoot through walls"]="Pucanje kroz zidove",["Max thickness"]="Maks. debljina",["Max surfaces"]="Maks. površine",["DISABLED"]="ONEMOGUĆENO",["Gun Mods"]="Oružje",["Settings"]="Postavke",["Theme"]="Tema",["Language"]="Jezik",["Interface"]="Sučelje",["Unload"]="Ukloni",["Always"]="Uvijek",["Toggle"]="Prebaci",["Hold"]="Drži",["Clear"]="Očisti",["Search..."]="Pretraži...",["Config"]="Konfiguracija",["Name"]="Ime",["Saved"]="Spremljeno",["Save"]="Spremi",["Load"]="Učitaj",["Delete"]="Izbriši",["Refresh"]="Osvježi",["Home: show / hide"]="Home: prikaži / sakrij"},
    ["Čeština (Czech)"]={["Aim"]="Míření",["Silent Aim"]="Tiché míření",["Team check"]="Kontrola týmu",["Prediction"]="Předpověď",["Show FOV"]="Zobrazit FOV",["FOV colour"]="Barva FOV",["Target part"]="Cílová část",["Head"]="Hlava",["Torso"]="Trup",["FOV radius"]="Poloměr FOV",["Max distance"]="Max. vzdálenost",["Shoot through walls"]="Střelba skrz zdi",["Max thickness"]="Max. tloušťka",["Max surfaces"]="Max. povrchy",["DISABLED"]="VYPNUTO",["Gun Mods"]="Zbraně",["Settings"]="Nastavení",["Theme"]="Motiv",["Language"]="Jazyk",["Interface"]="Rozhraní",["Unload"]="Ukončit",["Always"]="Vždy",["Toggle"]="Přepnout",["Hold"]="Držet",["Clear"]="Vymazat",["Search..."]="Hledat...",["Config"]="Konfigurace",["Name"]="Název",["Saved"]="Uložené",["Save"]="Uložit",["Load"]="Načíst",["Delete"]="Smazat",["Refresh"]="Obnovit",["Home: show / hide"]="Home: zobrazit / skrýt"},
    ["Dansk (Danish)"]={["Aim"]="Sigtning",["Silent Aim"]="Stille sigtning",["Team check"]="Holdkontrol",["Prediction"]="Forudsigelse",["Show FOV"]="Vis FOV",["FOV colour"]="FOV-farve",["Target part"]="Måldel",["Head"]="Hoved",["Torso"]="Overkrop",["FOV radius"]="FOV-radius",["Max distance"]="Maks afstand",["Shoot through walls"]="Skyd gennem vægge",["Max thickness"]="Maks tykkelse",["Max surfaces"]="Maks overflader",["DISABLED"]="DEAKTIVERET",["Gun Mods"]="Våben",["Settings"]="Indstillinger",["Theme"]="Tema",["Language"]="Sprog",["Interface"]="Grænseflade",["Unload"]="Afslut",["Always"]="Altid",["Toggle"]="Skift",["Hold"]="Hold",["Clear"]="Ryd",["Search..."]="Søg...",["Config"]="Konfiguration",["Name"]="Navn",["Saved"]="Gemte",["Save"]="Gem",["Load"]="Indlæs",["Delete"]="Slet",["Refresh"]="Opdater",["Home: show / hide"]="Home: vis / skjul"},
    ["Nederlands (Dutch)"]={["Aim"]="Richten",["Silent Aim"]="Stil richten",["Team check"]="Teamcontrole",["Prediction"]="Voorspelling",["Show FOV"]="Toon FOV",["FOV colour"]="FOV-kleur",["Target part"]="Doelonderdeel",["Head"]="Hoofd",["Torso"]="Romp",["FOV radius"]="FOV-straal",["Max distance"]="Max. afstand",["Shoot through walls"]="Door muren schieten",["Max thickness"]="Max. dikte",["Max surfaces"]="Max. oppervlakken",["DISABLED"]="UITGESCHAKELD",["Gun Mods"]="Wapens",["Settings"]="Instellingen",["Theme"]="Thema",["Language"]="Taal",["Interface"]="Interface",["Unload"]="Afsluiten",["Always"]="Altijd",["Toggle"]="Omschakelen",["Hold"]="Ingedrukt houden",["Clear"]="Wissen",["Search..."]="Zoeken...",["Config"]="Configuratie",["Name"]="Naam",["Saved"]="Opgeslagen",["Save"]="Opslaan",["Load"]="Laden",["Delete"]="Verwijderen",["Refresh"]="Vernieuwen",["Home: show / hide"]="Home: tonen / verbergen"},
    ["Eesti (Estonian)"]={["Aim"]="Sihtimine",["Silent Aim"]="Vaikne sihtimine",["Team check"]="Meeskonna kontroll",["Prediction"]="Ennustus",["Show FOV"]="Näita FOV",["FOV colour"]="FOV värv",["Target part"]="Sihtosa",["Head"]="Pea",["Torso"]="Kere",["FOV radius"]="FOV raadius",["Max distance"]="Max kaugus",["Shoot through walls"]="Läbi seinte laskmine",["Max thickness"]="Max paksus",["Max surfaces"]="Max pinnad",["DISABLED"]="KEELATUD",["Gun Mods"]="Relvad",["Settings"]="Seaded",["Theme"]="Teema",["Language"]="Keel",["Interface"]="Liides",["Unload"]="Sulge",["Always"]="Alati",["Toggle"]="Lülita",["Hold"]="Hoia",["Clear"]="Tühjenda",["Search..."]="Otsi...",["Config"]="Seadistus",["Name"]="Nimi",["Saved"]="Salvestatud",["Save"]="Salvesta",["Load"]="Laadi",["Delete"]="Kustuta",["Refresh"]="Värskenda",["Home: show / hide"]="Home: näita / peida"},
    ["Filipino"]={["Aim"]="Pagpuntirya",["Silent Aim"]="Tahimik na pagpuntirya",["Team check"]="Suriin ang koponan",["Prediction"]="Paghula",["Show FOV"]="Ipakita ang FOV",["FOV colour"]="Kulay ng FOV",["Target part"]="Bahagi ng target",["Head"]="Ulo",["Torso"]="Katawan",["FOV radius"]="Radius ng FOV",["Max distance"]="Pinakamalayong distansya",["Shoot through walls"]="Bumaril sa pader",["Max thickness"]="Pinakamakapal",["Max surfaces"]="Pinakamaraming ibabaw",["DISABLED"]="NAKA-DISABLE",["Gun Mods"]="Mga armas",["Settings"]="Mga setting",["Theme"]="Tema",["Language"]="Wika",["Interface"]="Interface",["Unload"]="Isara",["Always"]="Palagi",["Toggle"]="I-toggle",["Hold"]="Pindutin nang matagal",["Clear"]="Burahin",["Search..."]="Maghanap...",["Config"]="Config",["Name"]="Pangalan",["Saved"]="Naka-save",["Save"]="I-save",["Load"]="I-load",["Delete"]="Tanggalin",["Refresh"]="I-refresh",["Home: show / hide"]="Home: ipakita / itago"},
    ["Suomi (Finnish)"]={["Aim"]="Tähtäys",["Silent Aim"]="Hiljainen tähtäys",["Team check"]="Joukkuetarkistus",["Prediction"]="Ennustus",["Show FOV"]="Näytä FOV",["FOV colour"]="FOV-väri",["Target part"]="Kohdeosa",["Head"]="Pää",["Torso"]="Vartalo",["FOV radius"]="FOV-säde",["Max distance"]="Enimmäisetäisyys",["Shoot through walls"]="Ammu seinien läpi",["Max thickness"]="Enimmäispaksuus",["Max surfaces"]="Enimmäispinnat",["DISABLED"]="POIS KÄYTÖSTÄ",["Gun Mods"]="Aseet",["Settings"]="Asetukset",["Theme"]="Teema",["Language"]="Kieli",["Interface"]="Käyttöliittymä",["Unload"]="Sulje",["Always"]="Aina",["Toggle"]="Vaihda",["Hold"]="Pidä",["Clear"]="Tyhjennä",["Search..."]="Hae...",["Config"]="Määritys",["Name"]="Nimi",["Saved"]="Tallennetut",["Save"]="Tallenna",["Load"]="Lataa",["Delete"]="Poista",["Refresh"]="Päivitä",["Home: show / hide"]="Home: näytä / piilota"},
    ["ქართული (Georgian)"]={["Aim"]="დამიზნება",["Silent Aim"]="ჩუმი დამიზნება",["Team check"]="გუნდის შემოწმება",["Prediction"]="პროგნოზი",["Show FOV"]="FOV-ის ჩვენება",["FOV colour"]="FOV-ის ფერი",["Target part"]="სამიზნე ნაწილი",["Head"]="თავი",["Torso"]="ტორსი",["FOV radius"]="FOV-ის რადიუსი",["Max distance"]="მაქს. მანძილი",["Shoot through walls"]="კედლებში სროლა",["Max thickness"]="მაქს. სისქე",["Max surfaces"]="მაქს. ზედაპირები",["DISABLED"]="გამორთულია",["Gun Mods"]="იარაღი",["Settings"]="პარამეტრები",["Theme"]="თემა",["Language"]="ენა",["Interface"]="ინტერფეისი",["Unload"]="დახურვა",["Always"]="ყოველთვის",["Toggle"]="გადართვა",["Hold"]="დაჭერა",["Clear"]="გასუფთავება",["Search..."]="ძებნა...",["Config"]="კონფიგურაცია",["Name"]="სახელი",["Saved"]="შენახული",["Save"]="შენახვა",["Load"]="ჩატვირთვა",["Delete"]="წაშლა",["Refresh"]="განახლება",["Home: show / hide"]="Home: ჩვენება / დამალვა"},
    ["Ελληνικά (Greek)"]={["Aim"]="Στόχευση",["Silent Aim"]="Αθόρυβη στόχευση",["Team check"]="Έλεγχος ομάδας",["Prediction"]="Πρόβλεψη",["Show FOV"]="Εμφάνιση FOV",["FOV colour"]="Χρώμα FOV",["Target part"]="Μέρος στόχου",["Head"]="Κεφάλι",["Torso"]="Κορμός",["FOV radius"]="Ακτίνα FOV",["Max distance"]="Μέγ. απόσταση",["Shoot through walls"]="Βολή μέσα από τοίχους",["Max thickness"]="Μέγ. πάχος",["Max surfaces"]="Μέγ. επιφάνειες",["DISABLED"]="ΑΝΕΝΕΡΓΟ",["Gun Mods"]="Όπλα",["Settings"]="Ρυθμίσεις",["Theme"]="Θέμα",["Language"]="Γλώσσα",["Interface"]="Διεπαφή",["Unload"]="Κλείσιμο",["Always"]="Πάντα",["Toggle"]="Εναλλαγή",["Hold"]="Κράτημα",["Clear"]="Εκκαθάριση",["Search..."]="Αναζήτηση...",["Config"]="Διαμόρφωση",["Name"]="Όνομα",["Saved"]="Αποθηκευμένα",["Save"]="Αποθήκευση",["Load"]="Φόρτωση",["Delete"]="Διαγραφή",["Refresh"]="Ανανέωση",["Home: show / hide"]="Home: εμφάνιση / απόκρυψη"},
    ["हिन्दी (Hindi)"]={["Aim"]="निशाना",["Silent Aim"]="शांत निशाना",["Team check"]="टीम जाँच",["Prediction"]="पूर्वानुमान",["Show FOV"]="FOV दिखाएँ",["FOV colour"]="FOV रंग",["Target part"]="लक्ष्य का भाग",["Head"]="सिर",["Torso"]="धड़",["FOV radius"]="FOV त्रिज्या",["Max distance"]="अधिकतम दूरी",["Shoot through walls"]="दीवारों के पार गोली",["Max thickness"]="अधिकतम मोटाई",["Max surfaces"]="अधिकतम सतहें",["DISABLED"]="अक्षम",["Gun Mods"]="हथियार",["Settings"]="सेटिंग्स",["Theme"]="थीम",["Language"]="भाषा",["Interface"]="इंटरफ़ेस",["Unload"]="बंद करें",["Always"]="हमेशा",["Toggle"]="टॉगल",["Hold"]="दबाकर रखें",["Clear"]="साफ़ करें",["Search..."]="खोजें...",["Config"]="कॉन्फ़िग",["Name"]="नाम",["Saved"]="सहेजे गए",["Save"]="सहेजें",["Load"]="लोड करें",["Delete"]="हटाएँ",["Refresh"]="रीफ़्रेश",["Home: show / hide"]="Home: दिखाएँ / छिपाएँ"},
    ["Magyar (Hungarian)"]={["Aim"]="Célzás",["Silent Aim"]="Csendes célzás",["Team check"]="Csapatellenőrzés",["Prediction"]="Előrejelzés",["Show FOV"]="FOV mutatása",["FOV colour"]="FOV színe",["Target part"]="Célpont része",["Head"]="Fej",["Torso"]="Törzs",["FOV radius"]="FOV sugara",["Max distance"]="Max. távolság",["Shoot through walls"]="Lövés falon át",["Max thickness"]="Max. vastagság",["Max surfaces"]="Max. felületek",["DISABLED"]="LETILTVA",["Gun Mods"]="Fegyverek",["Settings"]="Beállítások",["Theme"]="Téma",["Language"]="Nyelv",["Interface"]="Felület",["Unload"]="Bezárás",["Always"]="Mindig",["Toggle"]="Váltás",["Hold"]="Nyomva tartás",["Clear"]="Törlés",["Search..."]="Keresés...",["Config"]="Konfiguráció",["Name"]="Név",["Saved"]="Mentett",["Save"]="Mentés",["Load"]="Betöltés",["Delete"]="Törlés",["Refresh"]="Frissítés",["Home: show / hide"]="Home: mutatás / elrejtés"},
    ["Bahasa Indonesia"]={["Aim"]="Bidikan",["Silent Aim"]="Bidikan senyap",["Team check"]="Periksa tim",["Prediction"]="Prediksi",["Show FOV"]="Tampilkan FOV",["FOV colour"]="Warna FOV",["Target part"]="Bagian target",["Head"]="Kepala",["Torso"]="Badan",["FOV radius"]="Radius FOV",["Max distance"]="Jarak maksimum",["Shoot through walls"]="Tembak menembus dinding",["Max thickness"]="Ketebalan maksimum",["Max surfaces"]="Permukaan maksimum",["DISABLED"]="DINONAKTIFKAN",["Gun Mods"]="Senjata",["Settings"]="Pengaturan",["Theme"]="Tema",["Language"]="Bahasa",["Interface"]="Antarmuka",["Unload"]="Tutup",["Always"]="Selalu",["Toggle"]="Beralih",["Hold"]="Tahan",["Clear"]="Hapus",["Search..."]="Cari...",["Config"]="Konfigurasi",["Name"]="Nama",["Saved"]="Tersimpan",["Save"]="Simpan",["Load"]="Muat",["Delete"]="Hapus",["Refresh"]="Segarkan",["Home: show / hide"]="Home: tampilkan / sembunyikan"},
    ["Italiano"]={["Aim"]="Mira",["Silent Aim"]="Mira silenziosa",["Team check"]="Controllo squadra",["Prediction"]="Previsione",["Show FOV"]="Mostra FOV",["FOV colour"]="Colore FOV",["Target part"]="Parte bersaglio",["Head"]="Testa",["Torso"]="Torso",["FOV radius"]="Raggio FOV",["Max distance"]="Distanza massima",["Shoot through walls"]="Spara attraverso i muri",["Max thickness"]="Spessore massimo",["Max surfaces"]="Superfici massime",["DISABLED"]="DISATTIVATO",["Gun Mods"]="Armi",["Settings"]="Impostazioni",["Theme"]="Tema",["Language"]="Lingua",["Interface"]="Interfaccia",["Unload"]="Scarica",["Always"]="Sempre",["Toggle"]="Attiva/disattiva",["Hold"]="Tieni premuto",["Clear"]="Cancella",["Search..."]="Cerca...",["Config"]="Configurazione",["Name"]="Nome",["Saved"]="Salvate",["Save"]="Salva",["Load"]="Carica",["Delete"]="Elimina",["Refresh"]="Aggiorna",["Home: show / hide"]="Home: mostra / nascondi"},
    ["日本語 (Japanese)"]={["Aim"]="照準",["Silent Aim"]="サイレントエイム",["Team check"]="チーム確認",["Prediction"]="予測",["Show FOV"]="FOVを表示",["FOV colour"]="FOVの色",["Target part"]="対象部位",["Head"]="頭",["Torso"]="胴体",["FOV radius"]="FOV半径",["Max distance"]="最大距離",["Shoot through walls"]="壁越し射撃",["Max thickness"]="最大厚さ",["Max surfaces"]="最大表面数",["DISABLED"]="無効",["Gun Mods"]="武器",["Settings"]="設定",["Theme"]="テーマ",["Language"]="言語",["Interface"]="インターフェース",["Unload"]="終了",["Always"]="常時",["Toggle"]="切り替え",["Hold"]="長押し",["Clear"]="解除",["Search..."]="検索...",["Config"]="設定ファイル",["Name"]="名前",["Saved"]="保存済み",["Save"]="保存",["Load"]="読み込み",["Delete"]="削除",["Refresh"]="更新",["Home: show / hide"]="Home: 表示 / 非表示"},
    ["Қазақша (Kazakh)"]={["Aim"]="Көздеу",["Silent Aim"]="Үнсіз көздеу",["Team check"]="Топты тексеру",["Prediction"]="Болжау",["Show FOV"]="FOV көрсету",["FOV colour"]="FOV түсі",["Target part"]="Нысана бөлігі",["Head"]="Бас",["Torso"]="Дене",["FOV radius"]="FOV радиусы",["Max distance"]="Ең үлкен қашықтық",["Shoot through walls"]="Қабырға арқылы ату",["Max thickness"]="Ең үлкен қалыңдық",["Max surfaces"]="Ең көп беттер",["DISABLED"]="ӨШІРІЛГЕН",["Gun Mods"]="Қарулар",["Settings"]="Баптаулар",["Theme"]="Тақырып",["Language"]="Тіл",["Interface"]="Интерфейс",["Unload"]="Жабу",["Always"]="Әрқашан",["Toggle"]="Ауыстыру",["Hold"]="Басып ұстау",["Clear"]="Тазалау",["Search..."]="Іздеу...",["Config"]="Конфигурация",["Name"]="Аты",["Saved"]="Сақталған",["Save"]="Сақтау",["Load"]="Жүктеу",["Delete"]="Жою",["Refresh"]="Жаңарту",["Home: show / hide"]="Home: көрсету / жасыру"},
    ["ខ្មែរ (Khmer)"]={["Aim"]="ការតម្រង់",["Silent Aim"]="ការតម្រង់ស្ងាត់",["Team check"]="ពិនិត្យក្រុម",["Prediction"]="ការព្យាករ",["Show FOV"]="បង្ហាញ FOV",["FOV colour"]="ពណ៌ FOV",["Target part"]="ផ្នែកគោលដៅ",["Head"]="ក្បាល",["Torso"]="ដងខ្លួន",["FOV radius"]="កាំ FOV",["Max distance"]="ចម្ងាយអតិបរមា",["Shoot through walls"]="បាញ់ឆ្លងជញ្ជាំង",["Max thickness"]="កម្រាស់អតិបរមា",["Max surfaces"]="ផ្ទៃអតិបរមា",["DISABLED"]="បានបិទ",["Gun Mods"]="អាវុធ",["Settings"]="ការកំណត់",["Theme"]="រូបរាង",["Language"]="ភាសា",["Interface"]="ផ្ទាំងបញ្ជា",["Unload"]="បិទ",["Always"]="ជានិច្ច",["Toggle"]="ប្ដូរ",["Hold"]="ចុចជាប់",["Clear"]="សម្អាត",["Search..."]="ស្វែងរក...",["Config"]="ការកំណត់រចនា",["Name"]="ឈ្មោះ",["Saved"]="បានរក្សាទុក",["Save"]="រក្សាទុក",["Load"]="ផ្ទុក",["Delete"]="លុប",["Refresh"]="ធ្វើឱ្យថ្មី",["Home: show / hide"]="Home: បង្ហាញ / លាក់"},
    ["한국어 (Korean)"]={["Aim"]="조준",["Silent Aim"]="사일런트 에임",["Team check"]="팀 확인",["Prediction"]="예측",["Show FOV"]="FOV 표시",["FOV colour"]="FOV 색상",["Target part"]="대상 부위",["Head"]="머리",["Torso"]="몸통",["FOV radius"]="FOV 반경",["Max distance"]="최대 거리",["Shoot through walls"]="벽 관통 사격",["Max thickness"]="최대 두께",["Max surfaces"]="최대 표면 수",["DISABLED"]="비활성화",["Gun Mods"]="무기",["Settings"]="설정",["Theme"]="테마",["Language"]="언어",["Interface"]="인터페이스",["Unload"]="종료",["Always"]="항상",["Toggle"]="전환",["Hold"]="길게 누르기",["Clear"]="해제",["Search..."]="검색...",["Config"]="설정 파일",["Name"]="이름",["Saved"]="저장된 항목",["Save"]="저장",["Load"]="불러오기",["Delete"]="삭제",["Refresh"]="새로고침",["Home: show / hide"]="Home: 표시 / 숨기기"},
    ["Latviešu (Latvian)"]={["Aim"]="Mērķēšana",["Silent Aim"]="Klusā mērķēšana",["Team check"]="Komandas pārbaude",["Prediction"]="Prognoze",["Show FOV"]="Rādīt FOV",["FOV colour"]="FOV krāsa",["Target part"]="Mērķa daļa",["Head"]="Galva",["Torso"]="Ķermenis",["FOV radius"]="FOV rādiuss",["Max distance"]="Maks. attālums",["Shoot through walls"]="Šaut caur sienām",["Max thickness"]="Maks. biezums",["Max surfaces"]="Maks. virsmas",["DISABLED"]="ATSPĒJOTS",["Gun Mods"]="Ieroči",["Settings"]="Iestatījumi",["Theme"]="Tēma",["Language"]="Valoda",["Interface"]="Saskarne",["Unload"]="Aizvērt",["Always"]="Vienmēr",["Toggle"]="Pārslēgt",["Hold"]="Turēt",["Clear"]="Notīrīt",["Search..."]="Meklēt...",["Config"]="Konfigurācija",["Name"]="Nosaukums",["Saved"]="Saglabātie",["Save"]="Saglabāt",["Load"]="Ielādēt",["Delete"]="Dzēst",["Refresh"]="Atsvaidzināt",["Home: show / hide"]="Home: rādīt / slēpt"},
    ["Lietuvių (Lithuanian)"]={["Aim"]="Taikymas",["Silent Aim"]="Tylus taikymas",["Team check"]="Komandos tikrinimas",["Prediction"]="Prognozė",["Show FOV"]="Rodyti FOV",["FOV colour"]="FOV spalva",["Target part"]="Taikinio dalis",["Head"]="Galva",["Torso"]="Liemuo",["FOV radius"]="FOV spindulys",["Max distance"]="Maks. atstumas",["Shoot through walls"]="Šaudyti per sienas",["Max thickness"]="Maks. storis",["Max surfaces"]="Maks. paviršiai",["DISABLED"]="IŠJUNGTA",["Gun Mods"]="Ginklai",["Settings"]="Nustatymai",["Theme"]="Tema",["Language"]="Kalba",["Interface"]="Sąsaja",["Unload"]="Uždaryti",["Always"]="Visada",["Toggle"]="Perjungti",["Hold"]="Laikyti",["Clear"]="Išvalyti",["Search..."]="Ieškoti...",["Config"]="Konfigūracija",["Name"]="Pavadinimas",["Saved"]="Išsaugoti",["Save"]="Išsaugoti",["Load"]="Įkelti",["Delete"]="Ištrinti",["Refresh"]="Atnaujinti",["Home: show / hide"]="Home: rodyti / slėpti"},
    ["Bahasa Melayu"]={["Aim"]="Sasaran",["Silent Aim"]="Sasaran senyap",["Team check"]="Semak pasukan",["Prediction"]="Ramalan",["Show FOV"]="Papar FOV",["FOV colour"]="Warna FOV",["Target part"]="Bahagian sasaran",["Head"]="Kepala",["Torso"]="Badan",["FOV radius"]="Jejari FOV",["Max distance"]="Jarak maksimum",["Shoot through walls"]="Tembak melalui dinding",["Max thickness"]="Ketebalan maksimum",["Max surfaces"]="Permukaan maksimum",["DISABLED"]="DINYAHAKTIFKAN",["Gun Mods"]="Senjata",["Settings"]="Tetapan",["Theme"]="Tema",["Language"]="Bahasa",["Interface"]="Antara muka",["Unload"]="Tutup",["Always"]="Sentiasa",["Toggle"]="Togol",["Hold"]="Tahan",["Clear"]="Kosongkan",["Search..."]="Cari...",["Config"]="Konfigurasi",["Name"]="Nama",["Saved"]="Disimpan",["Save"]="Simpan",["Load"]="Muat",["Delete"]="Padam",["Refresh"]="Segar semula",["Home: show / hide"]="Home: papar / sembunyi"},
    ["Română (Romanian)"]={["Aim"]="Țintire",["Silent Aim"]="Țintire silențioasă",["Team check"]="Verificare echipă",["Prediction"]="Predicție",["Show FOV"]="Arată FOV",["FOV colour"]="Culoare FOV",["Target part"]="Partea țintei",["Head"]="Cap",["Torso"]="Trunchi",["FOV radius"]="Rază FOV",["Max distance"]="Distanță maximă",["Shoot through walls"]="Trage prin pereți",["Max thickness"]="Grosime maximă",["Max surfaces"]="Suprafețe maxime",["DISABLED"]="DEZACTIVAT",["Gun Mods"]="Arme",["Settings"]="Setări",["Theme"]="Temă",["Language"]="Limbă",["Interface"]="Interfață",["Unload"]="Închide",["Always"]="Mereu",["Toggle"]="Comutare",["Hold"]="Ține apăsat",["Clear"]="Șterge",["Search..."]="Caută...",["Config"]="Configurație",["Name"]="Nume",["Saved"]="Salvate",["Save"]="Salvează",["Load"]="Încarcă",["Delete"]="Șterge",["Refresh"]="Reîmprospătează",["Home: show / hide"]="Home: arată / ascunde"},
    ["Русский (Russian)"]={["Aim"]="Прицеливание",["Silent Aim"]="Тихое прицеливание",["Team check"]="Проверка команды",["Prediction"]="Предсказание",["Show FOV"]="Показать FOV",["FOV colour"]="Цвет FOV",["Target part"]="Часть цели",["Head"]="Голова",["Torso"]="Торс",["FOV radius"]="Радиус FOV",["Max distance"]="Макс. расстояние",["Shoot through walls"]="Стрельба сквозь стены",["Max thickness"]="Макс. толщина",["Max surfaces"]="Макс. поверхности",["DISABLED"]="ОТКЛЮЧЕНО",["Gun Mods"]="Оружие",["Settings"]="Настройки",["Theme"]="Тема",["Language"]="Язык",["Interface"]="Интерфейс",["Unload"]="Выгрузить",["Always"]="Всегда",["Toggle"]="Переключение",["Hold"]="Удержание",["Clear"]="Очистить",["Search..."]="Поиск...",["Config"]="Конфигурация",["Name"]="Имя",["Saved"]="Сохранённые",["Save"]="Сохранить",["Load"]="Загрузить",["Delete"]="Удалить",["Refresh"]="Обновить",["Home: show / hide"]="Home: показать / скрыть"},
    ["Српски (Serbian)"]={["Aim"]="Нишањење",["Silent Aim"]="Тихо нишањење",["Team check"]="Провера тима",["Prediction"]="Предвиђање",["Show FOV"]="Прикажи FOV",["FOV colour"]="Боја FOV",["Target part"]="Део мете",["Head"]="Глава",["Torso"]="Труп",["FOV radius"]="Радијус FOV",["Max distance"]="Макс. удаљеност",["Shoot through walls"]="Пуцање кроз зидове",["Max thickness"]="Макс. дебљина",["Max surfaces"]="Макс. површине",["DISABLED"]="ИСКЉУЧЕНО",["Gun Mods"]="Оружје",["Settings"]="Подешавања",["Theme"]="Тема",["Language"]="Језик",["Interface"]="Интерфејс",["Unload"]="Затвори",["Always"]="Увек",["Toggle"]="Пребаци",["Hold"]="Држи",["Clear"]="Очисти",["Search..."]="Претражи...",["Config"]="Конфигурација",["Name"]="Име",["Saved"]="Сачувано",["Save"]="Сачувај",["Load"]="Учитај",["Delete"]="Избриши",["Refresh"]="Освежи",["Home: show / hide"]="Home: прикажи / сакриј"},
    ["සිංහල (Sinhala)"]={["Aim"]="ඉලක්ක කිරීම",["Silent Aim"]="නිහඬ ඉලක්ක කිරීම",["Team check"]="කණ්ඩායම් පරීක්ෂාව",["Prediction"]="පුරෝකථනය",["Show FOV"]="FOV පෙන්වන්න",["FOV colour"]="FOV වර්ණය",["Target part"]="ඉලක්ක කොටස",["Head"]="හිස",["Torso"]="කඳ",["FOV radius"]="FOV අරය",["Max distance"]="උපරිම දුර",["Shoot through walls"]="බිත්ති හරහා වෙඩි",["Max thickness"]="උපරිම ඝනකම",["Max surfaces"]="උපරිම පෘෂ්ඨ",["DISABLED"]="අක්‍රියයි",["Gun Mods"]="අවි",["Settings"]="සැකසුම්",["Theme"]="තේමාව",["Language"]="භාෂාව",["Interface"]="අතුරුමුහුණත",["Unload"]="වසන්න",["Always"]="සැමවිටම",["Toggle"]="මාරු කරන්න",["Hold"]="අල්ලා සිටින්න",["Clear"]="හිස් කරන්න",["Search..."]="සොයන්න...",["Config"]="වින්‍යාසය",["Name"]="නම",["Saved"]="සුරැකි",["Save"]="සුරකින්න",["Load"]="පූරණය",["Delete"]="මකන්න",["Refresh"]="නැවුම් කරන්න",["Home: show / hide"]="Home: පෙන්වන්න / සඟවන්න"},
    ["Slovenčina (Slovak)"]={["Aim"]="Mierenie",["Silent Aim"]="Tiché mierenie",["Team check"]="Kontrola tímu",["Prediction"]="Predpoveď",["Show FOV"]="Zobraziť FOV",["FOV colour"]="Farba FOV",["Target part"]="Cieľová časť",["Head"]="Hlava",["Torso"]="Trup",["FOV radius"]="Polomer FOV",["Max distance"]="Max. vzdialenosť",["Shoot through walls"]="Streľba cez steny",["Max thickness"]="Max. hrúbka",["Max surfaces"]="Max. povrchy",["DISABLED"]="VYPNUTÉ",["Gun Mods"]="Zbrane",["Settings"]="Nastavenia",["Theme"]="Motív",["Language"]="Jazyk",["Interface"]="Rozhranie",["Unload"]="Ukončiť",["Always"]="Vždy",["Toggle"]="Prepnúť",["Hold"]="Držať",["Clear"]="Vymazať",["Search..."]="Hľadať...",["Config"]="Konfigurácia",["Name"]="Názov",["Saved"]="Uložené",["Save"]="Uložiť",["Load"]="Načítať",["Delete"]="Zmazať",["Refresh"]="Obnoviť",["Home: show / hide"]="Home: zobraziť / skryť"},
    ["Slovenščina (Slovenian)"]={["Aim"]="Merjenje",["Silent Aim"]="Tiho merjenje",["Team check"]="Preverjanje ekipe",["Prediction"]="Napoved",["Show FOV"]="Prikaži FOV",["FOV colour"]="Barva FOV",["Target part"]="Del tarče",["Head"]="Glava",["Torso"]="Trup",["FOV radius"]="Polmer FOV",["Max distance"]="Največja razdalja",["Shoot through walls"]="Streljanje skozi stene",["Max thickness"]="Največja debelina",["Max surfaces"]="Največ površin",["DISABLED"]="ONEMOGOČENO",["Gun Mods"]="Orožje",["Settings"]="Nastavitve",["Theme"]="Tema",["Language"]="Jezik",["Interface"]="Vmesnik",["Unload"]="Zapri",["Always"]="Vedno",["Toggle"]="Preklop",["Hold"]="Drži",["Clear"]="Počisti",["Search..."]="Iskanje...",["Config"]="Konfiguracija",["Name"]="Ime",["Saved"]="Shranjeno",["Save"]="Shrani",["Load"]="Naloži",["Delete"]="Izbriši",["Refresh"]="Osveži",["Home: show / hide"]="Home: prikaži / skrij"},
    ["Svenska (Swedish)"]={["Aim"]="Sikte",["Silent Aim"]="Tyst sikte",["Team check"]="Lagkontroll",["Prediction"]="Förutsägelse",["Show FOV"]="Visa FOV",["FOV colour"]="FOV-färg",["Target part"]="Måldel",["Head"]="Huvud",["Torso"]="Överkropp",["FOV radius"]="FOV-radie",["Max distance"]="Max avstånd",["Shoot through walls"]="Skjut genom väggar",["Max thickness"]="Max tjocklek",["Max surfaces"]="Max ytor",["DISABLED"]="INAKTIVERAD",["Gun Mods"]="Vapen",["Settings"]="Inställningar",["Theme"]="Tema",["Language"]="Språk",["Interface"]="Gränssnitt",["Unload"]="Avsluta",["Always"]="Alltid",["Toggle"]="Växla",["Hold"]="Håll",["Clear"]="Rensa",["Search..."]="Sök...",["Config"]="Konfiguration",["Name"]="Namn",["Saved"]="Sparade",["Save"]="Spara",["Load"]="Ladda",["Delete"]="Ta bort",["Refresh"]="Uppdatera",["Home: show / hide"]="Home: visa / dölj"},
    ["ไทย (Thai)"]={["Aim"]="การเล็ง",["Silent Aim"]="เล็งแบบเงียบ",["Team check"]="ตรวจสอบทีม",["Prediction"]="การคาดการณ์",["Show FOV"]="แสดง FOV",["FOV colour"]="สี FOV",["Target part"]="ส่วนเป้าหมาย",["Head"]="หัว",["Torso"]="ลำตัว",["FOV radius"]="รัศมี FOV",["Max distance"]="ระยะสูงสุด",["Shoot through walls"]="ยิงทะลุกำแพง",["Max thickness"]="ความหนาสูงสุด",["Max surfaces"]="พื้นผิวสูงสุด",["DISABLED"]="ปิดใช้งาน",["Gun Mods"]="อาวุธ",["Settings"]="การตั้งค่า",["Theme"]="ธีม",["Language"]="ภาษา",["Interface"]="อินเทอร์เฟซ",["Unload"]="ปิด",["Always"]="ตลอดเวลา",["Toggle"]="สลับ",["Hold"]="กดค้าง",["Clear"]="ล้าง",["Search..."]="ค้นหา...",["Config"]="การกำหนดค่า",["Name"]="ชื่อ",["Saved"]="ที่บันทึก",["Save"]="บันทึก",["Load"]="โหลด",["Delete"]="ลบ",["Refresh"]="รีเฟรช",["Home: show / hide"]="Home: แสดง / ซ่อน"},
    ["Türkçe (Turkish)"]={["Aim"]="Nişan",["Silent Aim"]="Sessiz nişan",["Team check"]="Takım kontrolü",["Prediction"]="Tahmin",["Show FOV"]="FOV göster",["FOV colour"]="FOV rengi",["Target part"]="Hedef bölgesi",["Head"]="Baş",["Torso"]="Gövde",["FOV radius"]="FOV yarıçapı",["Max distance"]="Maks. mesafe",["Shoot through walls"]="Duvarların içinden ateş",["Max thickness"]="Maks. kalınlık",["Max surfaces"]="Maks. yüzey",["DISABLED"]="DEVRE DIŞI",["Gun Mods"]="Silahlar",["Settings"]="Ayarlar",["Theme"]="Tema",["Language"]="Dil",["Interface"]="Arayüz",["Unload"]="Kapat",["Always"]="Her zaman",["Toggle"]="Aç/kapat",["Hold"]="Basılı tut",["Clear"]="Temizle",["Search..."]="Ara...",["Config"]="Yapılandırma",["Name"]="Ad",["Saved"]="Kayıtlı",["Save"]="Kaydet",["Load"]="Yükle",["Delete"]="Sil",["Refresh"]="Yenile",["Home: show / hide"]="Home: göster / gizle"},
    ["Українська (Ukrainian)"]={["Aim"]="Прицілювання",["Silent Aim"]="Тихе прицілювання",["Team check"]="Перевірка команди",["Prediction"]="Передбачення",["Show FOV"]="Показати FOV",["FOV colour"]="Колір FOV",["Target part"]="Частина цілі",["Head"]="Голова",["Torso"]="Торс",["FOV radius"]="Радіус FOV",["Max distance"]="Макс. відстань",["Shoot through walls"]="Стрільба крізь стіни",["Max thickness"]="Макс. товщина",["Max surfaces"]="Макс. поверхні",["DISABLED"]="ВИМКНЕНО",["Gun Mods"]="Зброя",["Settings"]="Налаштування",["Theme"]="Тема",["Language"]="Мова",["Interface"]="Інтерфейс",["Unload"]="Вивантажити",["Always"]="Завжди",["Toggle"]="Перемикання",["Hold"]="Утримання",["Clear"]="Очистити",["Search..."]="Пошук...",["Config"]="Конфігурація",["Name"]="Назва",["Saved"]="Збережені",["Save"]="Зберегти",["Load"]="Завантажити",["Delete"]="Видалити",["Refresh"]="Оновити",["Home: show / hide"]="Home: показати / сховати"},
    ["Tiếng Việt (Vietnamese)"]={["Aim"]="Ngắm",["Silent Aim"]="Ngắm im lặng",["Team check"]="Kiểm tra đội",["Prediction"]="Dự đoán",["Show FOV"]="Hiện FOV",["FOV colour"]="Màu FOV",["Target part"]="Bộ phận mục tiêu",["Head"]="Đầu",["Torso"]="Thân",["FOV radius"]="Bán kính FOV",["Max distance"]="Khoảng cách tối đa",["Shoot through walls"]="Bắn xuyên tường",["Max thickness"]="Độ dày tối đa",["Max surfaces"]="Số bề mặt tối đa",["DISABLED"]="ĐÃ TẮT",["Gun Mods"]="Vũ khí",["Settings"]="Cài đặt",["Theme"]="Giao diện",["Language"]="Ngôn ngữ",["Interface"]="Bảng điều khiển",["Unload"]="Đóng",["Always"]="Luôn luôn",["Toggle"]="Bật/tắt",["Hold"]="Giữ",["Clear"]="Xóa",["Search..."]="Tìm kiếm...",["Config"]="Cấu hình",["Name"]="Tên",["Saved"]="Đã lưu",["Save"]="Lưu",["Load"]="Tải",["Delete"]="Xóa",["Refresh"]="Làm mới",["Home: show / hide"]="Home: hiện / ẩn"},
    ["English"]={["Config"]="Config",["Name"]="Name",["Saved"]="Saved",["Save"]="Save",["Load"]="Load",["Delete"]="Delete",["Refresh"]="Refresh",["Loaded"]="Loaded",["Deleted"]="Deleted",["Refreshed"]="Refreshed",["Session storage only"]="Session storage only",["Connecting to server..."]="Connecting to server...",["Loading interface..."]="Loading interface...",["Ready"]="Ready"},
    ["Español"]={["Config"]="Configuración",["Name"]="Nombre",["Saved"]="Guardados",["Save"]="Guardar",["Load"]="Cargar",["Delete"]="Eliminar",["Refresh"]="Actualizar",["Loaded"]="Cargado",["Deleted"]="Eliminado",["Refreshed"]="Actualizado",["Session storage only"]="Solo esta sesión",["Connecting to server..."]="Conectando al servidor...",["Loading interface..."]="Cargando interfaz...",["Ready"]="Listo"},
    ["Français"]={["Config"]="Configuration",["Name"]="Nom",["Saved"]="Enregistrés",["Save"]="Enregistrer",["Load"]="Charger",["Delete"]="Supprimer",["Refresh"]="Actualiser",["Loaded"]="Chargé",["Deleted"]="Supprimé",["Refreshed"]="Actualisé",["Session storage only"]="Stockage de session uniquement",["Connecting to server..."]="Connexion au serveur...",["Loading interface..."]="Chargement de l’interface...",["Ready"]="Prêt"},
    ["Deutsch"]={["Config"]="Konfiguration",["Name"]="Name",["Saved"]="Gespeichert",["Save"]="Speichern",["Load"]="Laden",["Delete"]="Löschen",["Refresh"]="Aktualisieren",["Loaded"]="Geladen",["Deleted"]="Gelöscht",["Refreshed"]="Aktualisiert",["Session storage only"]="Nur Sitzungsspeicher",["Connecting to server..."]="Verbindung zum Server...",["Loading interface..."]="Oberfläche wird geladen...",["Ready"]="Bereit"},
    ["Português"]={["Config"]="Configuração",["Name"]="Nome",["Saved"]="Salvos",["Save"]="Salvar",["Load"]="Carregar",["Delete"]="Excluir",["Refresh"]="Atualizar",["Loaded"]="Carregado",["Deleted"]="Excluído",["Refreshed"]="Atualizado",["Session storage only"]="Somente nesta sessão",["Connecting to server..."]="Conectando ao servidor...",["Loading interface..."]="Carregando interface...",["Ready"]="Pronto"},
    ["Polski"]={["Config"]="Konfiguracja",["Name"]="Nazwa",["Saved"]="Zapisane",["Save"]="Zapisz",["Load"]="Wczytaj",["Delete"]="Usuń",["Refresh"]="Odśwież",["Loaded"]="Wczytano",["Deleted"]="Usunięto",["Refreshed"]="Odświeżono",["Session storage only"]="Tylko bieżąca sesja",["Connecting to server..."]="Łączenie z serwerem...",["Loading interface..."]="Ładowanie interfejsu...",["Ready"]="Gotowe"},
}
for language,pack in pairs(ExtraTranslations) do
    Translations[language]=Translations[language] or {}
    for key,value in pairs(pack) do Translations[language][key]=value end
    local t=Translations[language]
    t['Shoot through walls (Disabled)']=t['Shoot through walls (Disabled)'] or (t['Shoot through walls'] or 'Shoot through walls')..' ('..(t['DISABLED'] or 'Disabled')..')'
    t['Loaded']=t['Loaded'] or t['Load']; t['Deleted']=t['Deleted'] or t['Delete']; t['Refreshed']=t['Refreshed'] or t['Refresh']
end
Translations['English (UK)']=Translations.English
Translations['Français (Canada)']=Translations['Français']
Translations['Português (Portugal)']=Translations['Português']
Translations['Español (México)']=Translations['Español']
local LanguageOptions={}
for language in pairs(Translations) do table.insert(LanguageOptions,language) end
table.sort(LanguageOptions,function(a,b) if a==b then return false elseif a=='English' then return true elseif b=='English' then return false end; return a<b end)
local function tr(value) return (Translations[currentLanguage] or {})[value] or value end

local Themes = {
    Fanta = {Accent=Color3.fromRGB(255,155,44), Secondary=Color3.fromRGB(76,192,225)},
    Halloween = {Accent=Color3.fromRGB(255,124,38), Secondary=Color3.fromRGB(167,91,224)},
    Christmas = {Accent=Color3.fromRGB(235,76,85), Secondary=Color3.fromRGB(67,183,112)},
}
local accent = Themes.Fanta.Accent
local grey = Color3.fromRGB(139, 139, 139)
local white = Color3.fromRGB(202, 202, 202)
local function rgb(n) return Color3.fromRGB(n,n,n) end
local function new(class, p, parent)
    local o = Instance.new(class)
    for k,v in pairs(p) do o[k] = v end
    o.Parent = parent
    return o
end
local function frame(parent,x,y,w,h,color)
    return new('Frame',{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=color or rgb(20),BorderSizePixel=0},parent)
end
local function text(parent,s,x,y,w,h,color)
    local label=new('TextLabel',{Text=tr(s),Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=1,Font=Enum.Font.Code,TextSize=11,TextColor3=color or white,TextXAlignment=Enum.TextXAlignment.Left},parent)
    if s~='' then label:SetAttribute('SourceText',s) end
    return label
end
local function hit(parent,x,y,w,h)
    return new('TextButton',{Text='',Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=1,BorderSizePixel=0,AutoButtonColor=false},parent)
end
local function border(o,c)
    new('UIStroke',{Color=c or rgb(46),Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},o)
end
local function gradient(o)
    new('UIGradient',{Rotation=90,Color=ColorSequence.new(accent:Lerp(Color3.new(1,1,1),0.13),accent:Lerp(Color3.new(0,0,0),0.2))},o)
end
-- One rotating shared key, read from a plain-text GitHub file.
local function checkSharedKey(key,raw)
    if type(raw)~='string' or #raw>1024 then return false,'Could not read the current key.' end
    if raw:sub(1,3)=='\239\187\191' then raw=raw:sub(4) end
    local expected=raw:match('^%s*(.-)%s*$')
    key=tostring(key):match('^%s*(.-)%s*$')
    if #expected<1 or #expected>256 or expected:find('[\r\n]') then return false,'The key file must contain one key on one line.' end
    local accepted=key==expected
    return accepted,accepted and 'Key accepted.' or 'Invalid key. Get the current key from Discord.'
end
local function requireKey()
    local prompt=new('ScreenGui',{Name='FantaKeyPrompt',ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=2147483647,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},player:WaitForChild('PlayerGui'))
    local panel=frame(prompt,0,0,380,220,rgb(17));panel.Position=UDim2.fromScale(0.5,0.5);panel.AnchorPoint=Vector2.new(0.5,0.5);border(panel,rgb(48))
    local fit=new('UIScale',{Scale=1},panel)
    local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if viewport then fit.Scale=math.max(0.2,math.min(1,(viewport.X-20)/380,(viewport.Y-20)/220)) end
    frame(panel,0,0,380,2,Themes.Fanta.Accent)
    local heading=text(panel,'FANTA',22,15,300,34,Themes.Fanta.Accent);heading.Font=Enum.Font.GothamBlack;heading.TextSize=27
    text(panel,'Enter your access key',23,54,330,22,grey)
    local entry=new('TextBox',{Position=UDim2.fromOffset(23,87),Size=UDim2.fromOffset(334,29),BackgroundColor3=rgb(27),BorderSizePixel=0,Text='',PlaceholderText='Enter key',PlaceholderColor3=grey,TextColor3=white,Font=Enum.Font.Code,TextSize=12,ClearTextOnFocus=false,TextXAlignment=Enum.TextXAlignment.Center},panel)
    border(entry,rgb(48))
    local verify=hit(panel,23,130,334,30);verify.BackgroundTransparency=0;verify.BackgroundColor3=Themes.Fanta.Accent
    local verifyLabel=text(verify,'Verify key',0,0,334,30,rgb(16));verifyLabel.Font=Enum.Font.GothamBold;verifyLabel.TextXAlignment=Enum.TextXAlignment.Center
    local status=text(panel,'Get the current key from Discord.',23,172,334,35,grey);status.TextWrapped=true;status.TextSize=11
    local close=hit(panel,345,8,27,27);text(close,'×',0,0,27,27,grey).TextXAlignment=Enum.TextXAlignment.Center
    local done=Instance.new('BindableEvent')
    local connections={};local finished,authorized,busy=false,false,false;local generation=0
    local function listen(signal,callback) local c=signal:Connect(callback);table.insert(connections,c) end
    local function finish(success)
        if finished then return end
        finished=true;authorized=success;generation=generation+1
        for _,c in ipairs(connections) do c:Disconnect() end
        prompt:Destroy();done:Fire()
    end
    local function submit()
        if finished or busy then return end
        local key=entry.Text:match('^%s*(.-)%s*$')
        if #key<1 or #key>256 then status.Text='Enter a valid key.';return end
        busy=true;generation=generation+1;local requestID=generation
        verifyLabel.Text='Checking...';status.Text='Checking your key...'
        task.delay(15,function()
            if finished or generation~=requestID or not busy then return end
            generation=generation+1;busy=false;verifyLabel.Text='Verify key';status.Text='Request timed out. Try again.'
        end)
        task.spawn(function()
            -- Fetch the current shared key. The entered text is never uploaded.
            local separator=KEY_URL:find('?',1,true) and '&' or '?'
            local ok,raw=pcall(function() return game:HttpGet(KEY_URL..separator..'t='..tostring(os.time())) end)
            if finished or generation~=requestID then return end
            busy=false;verifyLabel.Text='Verify key'
            if not ok then status.Text='Could not check the key. Check your connection and try again.';return end
            local accepted,message=checkSharedKey(key,raw)
            if accepted then entry.Text='';finish(true) else status.Text=message end
        end)
    end
    listen(verify.Activated,submit)
    listen(entry.FocusLost,function(enterPressed) if enterPressed then submit() end end)
    listen(close.Activated,function() finish(false) end)
    listen(prompt.Destroying,function() finish(false) end)
    while not finished do done.Event:Wait() end
    done:Destroy()
    return authorized
end

function Library:Window(options)
    options = options or {}
    local win, connections, tabs = {}, {}, {}
    local dead, interaction, dropClose = false, nil, nil
    local capturing=nil
    local themeRenderers, tabTweens, fadeRestore = {}, {}, {}
    local registry={}
    local requestedScale=1
    local function register(id,kind,control) registry[id]={Kind=kind,Control=control}; return control end
    local gui = new('ScreenGui',{Name='FantaUI',ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true,DisplayOrder=2147483647},player:WaitForChild('PlayerGui'))
    local root = frame(gui,0,0,756,536,rgb(14))
    root.ZIndex=2
    root.Position=UDim2.fromScale(0.5,0.5); root.AnchorPoint=Vector2.new(0.5,0.5)
    border(root,rgb(62))
    local scale=new('UIScale',{Scale=1},root)
    local function on(signal,fn)
        local c=signal:Connect(fn); table.insert(connections,c); return c
    end
    -- All floating controls share one layer above the menu body and its sections.
    -- Parent hierarchy matters with Sibling ZIndexBehaviour, not just each label's ZIndex.
    local popupLayer=frame(root,0,0,756,536)
    popupLayer.BackgroundTransparency=1; popupLayer.ZIndex=80
    local mountedPopups={}
    local function mountPopup(popup,anchor)
        popup.Parent=popupLayer
        local function place()
            local uiScale=math.max(scale.Scale,0.01)
            local x=(anchor.AbsolutePosition.X-root.AbsolutePosition.X)/uiScale
            local anchorY=(anchor.AbsolutePosition.Y-root.AbsolutePosition.Y)/uiScale
            local y=anchorY+anchor.AbsoluteSize.Y/uiScale+3
            local width,height=popup.Size.X.Offset,popup.Size.Y.Offset
            local windowWidth,windowHeight=root.Size.X.Offset,root.Size.Y.Offset
            if y+height>windowHeight-5 and anchorY-height-3>=5 then y=anchorY-height-3 end
            x=math.clamp(x,5,math.max(5,windowWidth-width-5))
            y=math.clamp(y,5,math.max(5,windowHeight-height-5))
            popup.Position=UDim2.fromOffset(x,y)
        end
        table.insert(mountedPopups,{Popup=popup,Place=place})
        return place
    end
    on(RunService.RenderStepped,function()
        if not root.Visible then return end
        for _,entry in ipairs(mountedPopups) do if entry.Popup.Visible then entry.Place() end end
    end)
    local function call(fn,...)
        local args=table.pack(...)
        if fn then task.spawn(function() local ok,err=pcall(fn,table.unpack(args,1,args.n)); if not ok then warn('[SkeetUI] '..tostring(err)) end end) end
    end
    root.Visible=false; win.Ready=false
    local cameraConnection
    local function watchCamera()
        if cameraConnection then cameraConnection:Disconnect() end
        local camera=workspace.CurrentCamera
        local function fit()
            if camera then scale.Scale=math.max(0.1,math.min(requestedScale,(camera.ViewportSize.X-16)/756,(camera.ViewportSize.Y-16)/536)) end
        end
        if camera then cameraConnection=on(camera:GetPropertyChangedSignal('ViewportSize'),fit) end
        fit()
    end
    on(workspace:GetPropertyChangedSignal('CurrentCamera'),watchCamera); watchCamera()
    local tooltip=text(gui,'',0,0,260,23,white)
    tooltip.BackgroundTransparency=0; tooltip.BackgroundColor3=rgb(25); tooltip.Visible=false; tooltip.ZIndex=200; border(tooltip)
    local function tooltipAtMouse()
        local pos=UIS:GetMouseLocation(); local view=workspace.CurrentCamera.ViewportSize
        tooltip.Position=UDim2.fromOffset(math.clamp(pos.X+14,0,math.max(0,view.X-264)),math.clamp(pos.Y+16,0,math.max(0,view.Y-27)))
    end
    local function hover(object,message)
        on(object.MouseEnter,function()
            if not win.Ready or not root.Visible then return end
            tooltip.Text='  '..(type(message)=='function' and message() or tr(message)); tooltip.Visible=true; tooltipAtMouse()
        end)
        on(object.MouseLeave,function() tooltip.Visible=false end)
    end
    on(UIS.InputChanged,function(input) if tooltip.Visible then tooltipAtMouse() end end)
    local top=frame(root,0,0,756,2,Color3.new(1,1,1))
    new('UIGradient',{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(120,183,168)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(78,168,181)),ColorSequenceKeypoint.new(1,Color3.fromRGB(155,116,218))})},top)
    frame(root,0,2,756,28,rgb(18))
    text(root,options.Title or 'Fanta',10,5,100,20,accent)
    text(root,options.Subtitle or 'SCRIPT HUB',74,5,570,20,grey)
    frame(root,0,30,756,1,rgb(43))
    local drag=hit(root,0,2,680,28)
    local discord=frame(root,692,9,12,12,Color3.fromRGB(101,94,239))
    new('UICorner',{CornerRadius=UDim.new(0,3)},discord)
    -- Discord gamepad silhouette.
    local icon=frame(discord,2,3,8,6,Color3.new(1,1,1))
    new('UICorner',{CornerRadius=UDim.new(0,2)},icon)
    frame(icon,2,2,1,2,Color3.fromRGB(101,94,239))
    frame(icon,5,2,1,2,Color3.fromRGB(101,94,239))
    local invite=hit(root,687,3,23,25)
    on(invite.Activated,function()
        local url=options.DiscordURL or DISCORD_URL
        if not url:match('^https://discord%.gg/[%w%-]+$') and not url:match('^https://discord%.com/invite/[%w%-]+$') then
            warn('[Fanta] Add your Discord invite to DISCORD_URL at the top of the script.'); return
        end
        if type(setclipboard)=='function' then
            local ok=pcall(setclipboard,url)
            if ok then warn('[Fanta] Discord invite copied to clipboard.')
            else warn('[Fanta] Clipboard access failed.') end
        else warn('[Fanta] Clipboard is unavailable in this environment.') end
    end)
    local minimize=hit(root,711,3,22,25); text(minimize,'−',5,0,18,25,grey)
    local close=hit(root,733,3,22,25); text(close,'×',5,0,18,25,grey)
    local body=frame(root,0,31,756,505,rgb(14))
    frame(body,0,0,148,505,rgb(17)); frame(body,148,0,1,505,rgb(43))
    frame(body,9,457,131,1,rgb(42))
    local avatar=new('ImageLabel',{Position=UDim2.fromOffset(11,467),Size=UDim2.fromOffset(28,28),BackgroundColor3=rgb(31),BorderSizePixel=0,ScaleType=Enum.ScaleType.Fit,Image=''},body)
    border(avatar,rgb(43))
    text(body,player.Name,46,463,98,27,white)
    task.spawn(function()
        -- Roblox supplies the signed-in player's headshot automatically.
        for attempt=1,3 do
            local ok,url,ready=pcall(function()
                return Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
            end)
            if dead then return end
            if ok and ready then avatar.Image=url; return end
            task.wait(1)
        end
    end)
    -- Persistent theme artwork in the menu sidebar, above the avatar.
    -- Drawn with native GUI shapes: no external image assets are needed.
    local artwork=frame(body,15,270,118,160)
    artwork.BackgroundTransparency=1
    local artGroups={}
    for _,name in ipairs({'Fanta','Halloween','Christmas'}) do
        local group=frame(artwork,0,0,118,160)
        group.BackgroundTransparency=1; group.Visible=false
        artGroups[name]=group
    end
    local function round(parent,x,y,w,h,color,radius)
        local shape=frame(parent,x,y,w,h,color)
        new('UICorner',{CornerRadius=UDim.new(0,radius or math.min(w,h)/2)},shape)
        return shape
    end
    local function triangle(parent,cx,y,width,height,color)
        -- Horizontal scanlines make a clean triangular silhouette.
        for row=0,height-1 do
            local span=math.max(1,math.floor(width*(row+1)/height))
            frame(parent,cx-math.floor(span/2),y+row,span,1,color)
        end
    end
    local fantaWord=text(artGroups.Fanta,'FANTA',0,57,118,42,Color3.fromRGB(255,155,44))
    fantaWord.Font=Enum.Font.GothamBlack; fantaWord.TextSize=30
    fantaWord.TextXAlignment=Enum.TextXAlignment.Center
    local pumpkin=artGroups.Halloween
    local stem=round(pumpkin,56,39,10,24,Color3.fromRGB(92,119,45),3); stem.Rotation=14
    round(pumpkin,20,64,78,63,Color3.fromRGB(210,83,17),27)
    round(pumpkin,27,59,63,73,Color3.fromRGB(241,114,23),27)
    round(pumpkin,39,57,40,78,Color3.fromRGB(255,142,30),22)
    triangle(pumpkin,43,78,17,14,Color3.fromRGB(49,24,16))
    triangle(pumpkin,76,78,17,14,Color3.fromRGB(49,24,16))
    triangle(pumpkin,59,94,10,10,Color3.fromRGB(49,24,16))
    round(pumpkin,37,109,45,12,Color3.fromRGB(49,24,16),5)
    frame(pumpkin,46,108,6,7,Color3.fromRGB(255,142,30))
    frame(pumpkin,67,116,6,6,Color3.fromRGB(255,142,30))
    local tree=artGroups.Christmas
    frame(tree,54,113,12,24,Color3.fromRGB(129,83,46))
    triangle(tree,60,68,92,59,Color3.fromRGB(29,121,69))
    triangle(tree,60,47,73,55,Color3.fromRGB(35,148,81))
    triangle(tree,60,28,52,49,Color3.fromRGB(46,173,93))
    local star=text(tree,'★',45,13,30,30,Color3.fromRGB(255,213,84))
    star.Font=Enum.Font.SourceSansBold; star.TextSize=29; star.TextXAlignment=Enum.TextXAlignment.Center
    for _,point in ipairs({{49,62},{69,79},{41,97},{78,108},{58,114}}) do
        round(tree,point[1],point[2],7,7,Color3.fromRGB(235,71,74),4)
    end
    for _,point in ipairs({{67,57},{51,84},{29,113},{88,119}}) do
        round(tree,point[1],point[2],5,5,Color3.fromRGB(255,217,112),3)
    end
    for _,object in ipairs(artwork:GetDescendants()) do object:SetAttribute('ThemeArtwork',true) end
    table.insert(themeRenderers,function(name)
        for themeName,group in pairs(artGroups) do group.Visible=themeName==name end
    end)
    local overlay=frame(gui,0,0,0,0)
    overlay.Size=UDim2.fromScale(1,1); overlay.BackgroundTransparency=1; overlay.ZIndex=1; overlay.Visible=false
    local fov=frame(overlay,0,0,320,320)
    fov.BackgroundTransparency=1; fov.Position=UDim2.fromScale(0.5,0.5)
    fov.AnchorPoint=Vector2.new(0.5,0.5); fov.Visible=false
    new('UICorner',{CornerRadius=UDim.new(1,0)},fov)
    local fovStroke=new('UIStroke',{Thickness=1.5,Color=Color3.new(1,1,1),ApplyStrokeMode=Enum.ApplyStrokeMode.Border},fov)
    local fovEnabled,fovRadius=false,160
    function win:SetFOVVisible(enabled)
        fovEnabled=enabled==true; fov.Visible=fovEnabled and fovRadius>0
    end
    function win:SetFOVRadius(radius)
        fovRadius=math.max(0,radius)
        fov.Size=UDim2.fromOffset(fovRadius*2,fovRadius*2)
        fov.Visible=fovEnabled and fovRadius>0
    end
    function win:SetFOVColor(color,opacity) fovStroke.Color=color; fovStroke.Transparency=1-(opacity or 1) end
    -- Fixed pool of snowflakes, clipped to the menu and independent of input.
    local snow=frame(body,0,0,756,505)
    snow.BackgroundTransparency=1; snow.ClipsDescendants=true; snow.ZIndex=50; snow.Visible=false
    local flakes={}; local random=Random.new()
    for i=1,45 do
        local size=random:NextInteger(2,4)
        local dot=round(snow,0,0,size,size,Color3.new(1,1,1),size/2)
        dot.ZIndex=50; dot.BackgroundTransparency=random:NextNumber(0.25,0.7)
        table.insert(flakes,{Dot=dot,X=random:NextNumber(0,756),Y=random:NextNumber(0,505),Speed=random:NextNumber(18,43),Phase=random:NextNumber(0,6.28)})
    end
    table.insert(themeRenderers,function(name) snow.Visible=name=='Christmas' end)
    local snowTime=0
    on(RunService.RenderStepped,function(dt)
        if not snow.Visible or not root.Visible or not body.Visible then return end
        dt=math.min(dt,0.1); snowTime=snowTime+dt
        for _,flake in ipairs(flakes) do
            flake.Y=(flake.Y+flake.Speed*dt)%509
            flake.Dot.Position=UDim2.fromOffset(flake.X+math.sin(snowTime+flake.Phase)*8,flake.Y-4)
        end
    end)
    local resize=hit(root,0,0,20,20); resize.Position=UDim2.new(1,-20,1,-20); resize.ZIndex=60
    for row=0,3 do
        for col=0,row do local dot=frame(resize,17-col*4,5+row*4,2,2,grey); dot.ZIndex=61 end
    end
    on(resize.InputBegan,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            local start=input.Position; local initial=scale.Scale; local origin=root.AbsolutePosition
            interaction={Input=input,Move=function(pos)
                local camera=workspace.CurrentCamera; if not camera then return end
                local cap=math.min(1.8,(camera.ViewportSize.X-16)/756,(camera.ViewportSize.Y-16)/536)
                requestedScale=math.clamp(initial+math.max((pos.X-start.X)/756,(pos.Y-start.Y)/536),math.min(0.55,cap),cap)
                scale.Scale=requestedScale
                root.Position=UDim2.fromOffset(origin.X+756*requestedScale/2,origin.Y+536*requestedScale/2)
            end}
        end
    end)
    local function stopInteraction() interaction=nil end
    on(drag.InputBegan,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            local start,pos=input.Position,root.Position
            interaction={Input=input,Move=function(p)
                local d=p-start
                root.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
            end}
        end
    end)
    on(UIS.InputChanged,function(input)
        if interaction and (input==interaction.Input or (interaction.Input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)) then interaction.Move(input.Position) end
    end)
    on(UIS.InputEnded,function(input) if interaction and interaction.Input==input then stopInteraction() end end)
    on(UIS.WindowFocusReleased,stopInteraction)
    -- Smooth tab entrance. Restore base opacity before cancelling/restarting.
    local function cancelTabAnimation()
        for _,t in ipairs(tabTweens) do t:Cancel() end
        tabTweens={}
        for _,item in ipairs(fadeRestore) do
            if item.Object.Parent then item.Object[item.Property]=item.Value end
        end
        fadeRestore={}
    end
    local function animateTab(page)
        cancelTabAnimation()
        page.Position=UDim2.fromOffset(158,16)
        local info=TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
        local jump=TweenService:Create(page,info,{Position=UDim2.fromOffset(158,9)})
        table.insert(tabTweens,jump); jump:Play()
        for _,object in ipairs(page:GetDescendants()) do
            local properties={}
            if object:IsA('GuiObject') then table.insert(properties,'BackgroundTransparency') end
            if object:IsA('TextLabel') or object:IsA('TextButton') then table.insert(properties,'TextTransparency') end
            if object:IsA('ImageLabel') then table.insert(properties,'ImageTransparency') end
            if object:IsA('UIStroke') then table.insert(properties,'Transparency') end
            local goals={}
            for _,property in ipairs(properties) do
                local base=object[property]
                if base<1 then
                    table.insert(fadeRestore,{Object=object,Property=property,Value=base})
                    goals[property]=base; object[property]=1
                end
            end
            if next(goals) then
                local tween=TweenService:Create(object,info,goals)
                table.insert(tabTweens,tween); tween:Play()
            end
        end
    end
    function win:SetTheme(name)
        local theme=Themes[name]; assert(theme,'Unknown theme: '..tostring(name))
        cancelTabAnimation()
        local previous=accent; accent=theme.Accent
        for _,object in ipairs(root:GetDescendants()) do
            if object:GetAttribute('ThemeArtwork') or object:GetAttribute('CustomColor') then
                -- Theme artwork keeps its original colours.
            elseif object:IsA('GuiObject') then
                if object.BackgroundColor3==previous then object.BackgroundColor3=accent end
                if (object:IsA('TextLabel') or object:IsA('TextButton')) and object.TextColor3==previous then object.TextColor3=accent end
                if object:IsA('ScrollingFrame') then object.ScrollBarImageColor3=accent end
            elseif object:IsA('UIGradient') and object.Parent~=top and not object:GetAttribute('ThemeArtwork') then
                object.Color=ColorSequence.new(accent:Lerp(Color3.new(1,1,1),0.13),accent:Lerp(Color3.new(0,0,0),0.2))
            end
        end
        top:FindFirstChildOfClass('UIGradient').Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,theme.Secondary),
            ColorSequenceKeypoint.new(0.5,accent),
            ColorSequenceKeypoint.new(1,theme.Secondary),
        })
        win.Theme=name
        for _,render in ipairs(themeRenderers) do render(name) end
    end
    function win:SetLanguage(language)
        assert(Translations[language],'Unknown language')
        cancelTabAnimation(); if dropClose then dropClose() end
        currentLanguage=language; win.Language=language
        for _,object in ipairs(root:GetDescendants()) do
            local source=object:GetAttribute('SourceText')
            if source and (object:IsA('TextLabel') or object:IsA('TextButton')) then object.Text=tr(source) end
            if object:IsA('TextBox') and object:GetAttribute('SearchField') then object.PlaceholderText=tr('Search...') end
        end
        for _,render in ipairs(themeRenderers) do render(win.Theme or 'Fanta') end
    end
    local collapsed=false
    on(minimize.Activated,function()
        collapsed=not collapsed; body.Visible=not collapsed
        root.Size=UDim2.fromOffset(756,collapsed and 31 or 536)
        if dropClose then dropClose() end
        stopInteraction()
    end)
    function win:Destroy()
        if dead then return end
        dead=true
        cancelTabAnimation()
        for _,c in ipairs(connections) do c:Disconnect() end
        gui:Destroy()
    end
    on(close.Activated,function() win:Destroy() end)
    on(gui.Destroying,function() win:Destroy() end)
    on(UIS.InputBegan,function(input,processed)
        if win.Ready and not capturing and not UIS:GetFocusedTextBox() and input.KeyCode==Enum.KeyCode.Home then
            root.Visible=not root.Visible; tooltip.Visible=false; stopInteraction(); if dropClose then dropClose() end
        end
    end)
    function win:Tab(name)
        local tab={}; local index=#tabs
        local tabHit=hit(body,1,5+index*26,146,24)
        local tabBG=frame(tabHit,0,0,146,24,rgb(25)); tabBG.Visible=false
        local indicator=frame(tabHit,0,0,2,24,accent); indicator.Visible=false
        local caption=text(tabHit,name,11,0,130,24,grey)
        local page=new('ScrollingFrame',{Position=UDim2.fromOffset(158,9),Size=UDim2.fromOffset(590,488),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=accent,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},body)
        local columns={}
        for i=1,2 do
            local column=frame(page,(i-1)*299+1,1,288,0)
            column.BackgroundTransparency=1; column.AutomaticSize=Enum.AutomaticSize.Y
            new('UIListLayout',{Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder},column)
            columns[i]=column
        end
        local function select()
            stopInteraction(); if dropClose then dropClose() end
            cancelTabAnimation()
            for _,t in ipairs(tabs) do
                local selected=t.Tab==tab
                t.Page.Visible=selected; t.BG.Visible=selected; t.Indicator.Visible=selected
                t.Caption.TextColor3=selected and white or grey
            end
            animateTab(page)
        end
        table.insert(tabs,{Tab=tab,Page=page,BG=tabBG,Indicator=indicator,Caption=caption})
        on(tabHit.Activated,select); if #tabs==1 then select() end
        function tab:Section(title,side)
            local section={}; local y=29; local sectionID=name..'/'..title
            local panel=frame(columns[side=='Right' and 2 or 1],0,0,288,40,rgb(20)); border(panel)
            frame(panel,8,7,2,10,accent)
            text(panel,title,16,2,266,19)
            frame(panel,8,22,270,1,rgb(43))
            local function reserve(height)
                local topY=y; y=y+height; panel.Size=UDim2.fromOffset(288,y+9); return topY
            end
            function section:Toggle(title,default,callback)
                local value=default==true; local disabled=false; local rowY=reserve(24)
                local row=hit(panel,8,rowY,270,24)
                local box=frame(row,1,7,8,8,rgb(12)); border(box,rgb(0))
                local g=new('UIGradient',{Rotation=90,Color=ColorSequence.new(accent:Lerp(Color3.new(1,1,1),0.15),accent:Lerp(Color3.new(0,0,0),0.15))},box)
                local cap=text(row,title,18,0,250,24)
                local control={}
                function control:Set(v,silent)
                    value=not disabled and v==true; box.BackgroundColor3=value and Color3.new(1,1,1) or rgb(12)
                    g.Enabled=value; cap.TextColor3=value and white or grey
                    if not silent then call(callback,value) end
                end
                function control:Get() return value end
                on(row.Activated,function() if not disabled then control:Set(not value) end end)
                function control:SetDisabled(state)
                    disabled=state==true; cap.TextTransparency=disabled and 0.45 or 0
                end
                function control:Keybind()
                    local bind,mode,held=nil,'Toggle',false
                    row.Size=UDim2.fromOffset(188,24); cap.Size=UDim2.fromOffset(170,24)
                    local name=text(panel,'',198,rowY,52,24,grey); name.Visible=false
                    local dots=hit(panel,253,rowY+3,26,18)
                    local bindLabel=text(dots,'',0,0,56,18,grey); bindLabel.TextXAlignment=Enum.TextXAlignment.Right
                    local menu=frame(panel,139,rowY+24,139,84,rgb(25)); menu.Visible=false; menu.ZIndex=30; border(menu)
                    local placeMenu=mountPopup(menu,dots)
                    local modeRows={}
                    local function closeMenu() menu.Visible=false; if dropClose==closeMenu then dropClose=nil end end
                    local function paint()
                        dots.Position=UDim2.fromOffset(bind and 223 or 253,rowY+3)
                        dots.Size=UDim2.fromOffset(bind and 56 or 26,18)
                        bindLabel.Size=UDim2.new(1,0,1,0)
                        bindLabel.Text=capturing==control and '[...]' or bind and bind.Name:gsub('MouseButton','M') or mode=='Always' and tr('Always') or '...'
                        for _,entry in ipairs(modeRows) do entry.Label.Text=tr(entry.Mode) end
                        for _,entry in ipairs(modeRows) do
                            entry.Label.TextColor3=entry.Mode==mode and accent or white
                            entry.Button.BackgroundTransparency=entry.Mode==mode and 0 or 1
                            entry.Button.BackgroundColor3=accent:Lerp(rgb(20),0.82)
                        end
                    end
                    table.insert(themeRenderers,paint)
                    local function setMode(nextMode)
                        mode=nextMode; held=false
                        if mode=='Clear' then bind=nil; mode='Toggle'; control:Set(false)
                        elseif mode=='Always' then control:Set(true)
                        elseif mode=='Hold' then control:Set(false) end
                        closeMenu(); paint()
                    end
                    for i,kind in ipairs({'Always','Toggle','Hold','Clear'}) do
                        local b=hit(menu,2,(i-1)*20+2,135,20); b.ZIndex=31
                        local label=text(b,kind,7,0,125,20); label.ZIndex=32
                        table.insert(modeRows,{Mode=kind,Button=b,Label=label})
                        on(b.Activated,function() setMode(kind) end)
                    end
                    on(dots.Activated,function()
                        cancelTabAnimation(); if dropClose then dropClose() end
                        capturing=control; paint()
                    end)
                    on(dots.MouseButton2Click,function()
                        capturing=nil; cancelTabAnimation()
                        local open=not menu.Visible; if dropClose then dropClose() end
                        if open then placeMenu() end
                        menu.Visible=open; if open then dropClose=closeMenu end; paint()
                    end)
                    local function inputKey(input)
                        if input.UserInputType==Enum.UserInputType.Keyboard then return input.KeyCode end
                        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.MouseButton2 or input.UserInputType==Enum.UserInputType.MouseButton3 then return input.UserInputType end
                        return nil
                    end
                    on(UIS.InputBegan,function(input,processed)
                        if capturing==control then
                            if input.KeyCode==Enum.KeyCode.Escape then capturing=nil; paint(); return end
                            local key=inputKey(input)
                            if key then bind=key; capturing=nil; if mode=='Always' then mode='Toggle'; control:Set(false) end; paint() end
                            return
                        end
                        if capturing or processed or UIS:GetFocusedTextBox() or not bind or disabled then return end
                        if inputKey(input)==bind then
                            if mode=='Toggle' then control:Set(not control:Get())
                            elseif mode=='Hold' then held=true; control:Set(true) end
                        end
                    end)
                    on(UIS.InputEnded,function(input)
                        if held and inputKey(input)==bind then held=false; control:Set(false) end
                    end)
                    on(UIS.WindowFocusReleased,function() if held then held=false; control:Set(false) end end)
                    on(row.Activated,function() if mode=='Always' and not disabled then control:Set(true) end end)
                    paint()
                    local binding={}
                    function binding:Get() return {Key=bind and bind.Name or '',Type=bind and bind.Name:find('MouseButton',1,true) and 'Mouse' or 'Keyboard',Mode=mode} end
                    function binding:Set(data)
                        if type(data)~='table' then return end
                        local key=nil
                        if type(data.Key)=='string' and data.Key~='' then
                            local ok,result=pcall(function() return data.Type=='Mouse' and Enum.UserInputType[data.Key] or Enum.KeyCode[data.Key] end)
                            if ok then key=result end
                        end
                        bind=key
                        local nextMode=table.find({'Always','Toggle','Hold'},data.Mode) and data.Mode or 'Toggle'
                        setMode(nextMode)
                    end
                    register(sectionID..'/'..title..'/Keybind','Keybind',binding)
                    return binding
                end
                control:Set(value,true); return register(sectionID..'/'..title,'Toggle',control)
            end
            function section:Slider(title,min,max,default,step,suffix,callback)
                assert(max>min and (step or 1)>0,'Invalid slider range')
                step=step or 1; suffix=suffix or ''; local value
                local rowY=reserve(34)
                text(panel,title,26,rowY,190,15)
                local output=text(panel,'',205,rowY,73,15); output.TextXAlignment=Enum.TextXAlignment.Right
                local track=frame(panel,26,rowY+18,252,8,rgb(27)); border(track,rgb(0))
                local fill=frame(track,0,0,0,8,accent); gradient(fill)
                local catch=hit(panel,24,rowY+12,256,21)
                local control={}
                function control:Set(v,silent)
                    local n=math.clamp(min+math.round((v-min)/step)*step,min,max)
                    local changed=n~=value; value=n
                    fill.Size=UDim2.new((n-min)/(max-min),0,1,0)
                    output.Text=string.format('%.3f',n):gsub('0+$',''):gsub('%.$','')..suffix
                    if changed and not silent then call(callback,n) end
                end
                function control:Get() return value end
                on(catch.InputBegan,function(input)
                    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                        local function update(p)
                            if track.AbsoluteSize.X>0 then control:Set(min+math.clamp((p.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)*(max-min)) end
                        end
                        interaction={Input=input,Move=update}; update(input.Position)
                    end
                end)
                control:Set(default or min,true); return register(sectionID..'/'..title,'Slider',control)
            end
            function section:Label(s)
                return text(panel,s,8,reserve(18),270,18,grey)
            end
            function section:Dropdown(title,items,default,callback,searchable)
                assert(#items>0,'Dropdown needs items')
                local rowY=reserve(43); local selected
                text(panel,title,26,rowY,252,15)
                local field=frame(panel,26,rowY+18,252,18,rgb(26)); border(field,rgb(0))
                local valueLabel=text(field,'',5,0,226,18,grey)
                text(field,'+',238,0,12,18,grey)
                local toggle=hit(field,0,0,252,18)
                hover(toggle,function() return tr(title)..': '..tr(tostring(selected or '')) end)
                local header=searchable and 28 or 0
                local choices=frame(panel,26,rowY+37,252,80,rgb(24)); choices.ZIndex=20; choices.Visible=false; border(choices,rgb(0))
                local placeChoices=mountPopup(choices,field)
                local list=new('ScrollingFrame',{Position=UDim2.fromOffset(0,header),Size=UDim2.new(1,0,1,-header),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),ScrollBarThickness=3,ScrollBarImageColor3=accent,ZIndex=21},choices)
                local function closeDropdown() choices.Visible=false; tooltip.Visible=false; if dropClose==closeDropdown then dropClose=nil end end
                local optionRows={}; local search
                if searchable then
                    search=new('TextBox',{Position=UDim2.fromOffset(5,3),Size=UDim2.fromOffset(242,23),BackgroundColor3=rgb(17),BorderSizePixel=0,Text='',PlaceholderText=tr('Search...'),PlaceholderColor3=grey,TextColor3=white,Font=Enum.Font.Code,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,ZIndex=23},choices)
                    search:SetAttribute('SearchField',true)
                end
                local function filter()
                    local query=search and string.lower(search.Text) or ''; local yy=0
                    for _,option in ipairs(optionRows) do
                        local visible=query=='' or string.find(string.lower(tostring(option.Value)),query,1,true) or string.find(string.lower(tr(tostring(option.Value))),query,1,true)
                        option.Button.Visible=visible and true or false
                        if visible then option.Button.Position=UDim2.fromOffset(0,yy); yy=yy+20 end
                    end
                    choices.Size=UDim2.fromOffset(252,math.min(180,math.max(yy,20)+header))
                    list.CanvasSize=UDim2.fromOffset(0,yy)
                end
                local function paintOptions()
                    for _,option in ipairs(optionRows) do
                        local active=option.Value==selected
                        option.Button.BackgroundTransparency=active and 0 or 1
                        option.Button.BackgroundColor3=accent:Lerp(rgb(20),0.82)
                        option.Text.TextColor3=active and accent or white
                        option.Text.Text=(active and '• ' or '  ')..tr(tostring(option.Value))
                    end
                end
                table.insert(themeRenderers,function() valueLabel.Text=tr(tostring(selected or '')); paintOptions(); filter() end)
                if search then on(search:GetPropertyChangedSignal('Text'),filter) end
                local control={}
                function control:Set(v,silent)
                    cancelTabAnimation(); assert(table.find(items,v),'Unknown dropdown option')
                    selected=v; valueLabel.Text=tr(tostring(v)); closeDropdown(); paintOptions(); filter()
                    if not silent then call(callback,v) end
                end
                function control:Get() return selected end
                function control:SetOptions(values,preferred)
                    closeDropdown()
                    for _,option in ipairs(optionRows) do option.Button:Destroy() end
                    optionRows={}; items=values
                    if #items==0 then items={'—'} end
                    for i,item in ipairs(items) do
                        local b=hit(list,0,(i-1)*20,249,20); b.ZIndex=22
                        local t=text(b,'',5,0,239,20); t.ZIndex=23
                        table.insert(optionRows,{Button=b,Text=t,Value=item})
                        hover(b,function() return tr(tostring(item)) end)
                        on(b.MouseEnter,function() b.BackgroundTransparency=0; b.BackgroundColor3=accent:Lerp(rgb(20),0.75) end)
                        on(b.MouseLeave,paintOptions)
                        on(b.Activated,function() control:Set(item) end)
                    end
                    local choice=table.find(items,preferred) and preferred or table.find(items,selected) and selected or items[1]
                    control:Set(choice,true)
                end
                on(toggle.Activated,function()
                    cancelTabAnimation(); local open=not choices.Visible
                    if dropClose then dropClose() end
                    if search then search.Text=''; filter() end
                    if open then placeChoices() end
                    choices.Visible=open; if open then dropClose=closeDropdown end
                end)
                control:SetOptions(items,default or items[1])
                if title~='Saved' then register(sectionID..'/'..title,'Dropdown',control) end
                return control
            end
            function section:ColorPicker(title,default,callback)
                local rowY=reserve(26); local color=default or Color3.new(1,1,1)
                local h,s,v=color:ToHSV(); local opacity=1
                text(panel,title,26,rowY,210,22)
                local swatch=frame(panel,253,rowY+5,25,12,color); border(swatch,rgb(0)); swatch:SetAttribute('CustomColor',true)
                local click=hit(panel,248,rowY,30,23)
                local popup=frame(panel,26,rowY+25,200,201,rgb(20)); popup.Visible=false; popup.ZIndex=40; border(popup,rgb(0))
                local placePicker=mountPopup(popup,swatch)
                local sv=frame(popup,8,8,151,151,Color3.new(1,1,1)); sv.ZIndex=41
                local svGradient=new('UIGradient',{Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(h,1,1))},sv)
                local shade=frame(sv,0,0,151,151,Color3.new(0,0,0)); shade.ZIndex=42
                new('UIGradient',{Rotation=90,Transparency=NumberSequence.new(1,0)},shade)
                local svMarker=frame(sv,0,0,5,5,Color3.new(1,1,1)); svMarker.AnchorPoint=Vector2.new(0.5,0.5); svMarker.ZIndex=45; border(svMarker,rgb(0))
                local hue=frame(popup,171,8,12,151,Color3.new(1,1,1)); hue.ZIndex=41
                local rainbow={}
                for i=0,6 do table.insert(rainbow,ColorSequenceKeypoint.new(i/6,Color3.fromHSV(i/6,1,1))) end
                new('UIGradient',{Rotation=90,Color=ColorSequence.new(rainbow)},hue)
                local hueMarker=frame(hue,-2,0,16,4,Color3.new(1,1,1)); hueMarker.AnchorPoint=Vector2.new(0,0.5); hueMarker.ZIndex=45; border(hueMarker,rgb(0))
                local alpha=frame(popup,8,169,175,8,rgb(80)); alpha.ZIndex=41
                for x=0,34 do
                    for y=0,1 do
                        local tile=frame(alpha,x*5,y*4,5,4,(x+y)%2==0 and rgb(90) or rgb(45)); tile.ZIndex=41
                    end
                end
                local alphaFill=frame(alpha,0,0,175,8,color); alphaFill.ZIndex=42
                new('UIGradient',{Transparency=NumberSequence.new(1,0)},alphaFill)
                local alphaMarker=frame(alpha,0,-1,3,10,Color3.new(1,1,1)); alphaMarker.ZIndex=45; border(alphaMarker,rgb(0))
                local hex=new('TextBox',{Position=UDim2.fromOffset(8,183),Size=UDim2.fromOffset(72,16),BackgroundColor3=rgb(28),BorderSizePixel=0,Text='',ClearTextOnFocus=false,TextColor3=white,Font=Enum.Font.Code,TextSize=10,ZIndex=45},popup)
                local rgbLabel=text(popup,'',86,182,108,17,grey); rgbLabel.ZIndex=45; rgbLabel.TextSize=10
                local function update(silent)
                    color=Color3.fromHSV(h,s,v)
                    swatch.BackgroundColor3=color; alphaFill.BackgroundColor3=color
                    svGradient.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(h,1,1))
                    svMarker.Position=UDim2.fromScale(s,1-v)
                    hueMarker.Position=UDim2.new(0,-2,h,0)
                    alphaMarker.Position=UDim2.new(opacity,opacity==1 and -2 or 0,0,-1)
                    local r,g,b=math.round(color.R*255),math.round(color.G*255),math.round(color.B*255)
                    hex.Text=string.format('#%02x%02x%02x',r,g,b)
                    rgbLabel.Text=string.format('%d, %d, %d',r,g,b)
                    if not silent then call(callback,color,opacity) end
                end
                local function draggable(target,width,height,updateValue)
                    local catch=hit(target,0,0,width,height); catch.ZIndex=46
                    on(catch.InputBegan,function(input)
                        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                            local function move(position)
                                if target.AbsoluteSize.X<=0 or target.AbsoluteSize.Y<=0 then return end
                                local x=math.clamp((position.X-target.AbsolutePosition.X)/target.AbsoluteSize.X,0,1)
                                local y=math.clamp((position.Y-target.AbsolutePosition.Y)/target.AbsoluteSize.Y,0,1)
                                updateValue(x,y); update(false)
                            end
                            interaction={Input=input,Move=move}; move(input.Position)
                        end
                    end)
                end
                draggable(sv,151,151,function(x,y) s=x; v=1-y end)
                draggable(hue,12,151,function(_,y) h=y end)
                draggable(alpha,175,8,function(x) opacity=x end)
                local function closePicker() popup.Visible=false; if dropClose==closePicker then dropClose=nil end end
                on(hex.FocusLost,function()
                    local value=hex.Text:gsub('#','')
                    if value:match('^%x%x%x%x%x%x$') then
                        local r=tonumber(value:sub(1,2),16); local g=tonumber(value:sub(3,4),16); local b=tonumber(value:sub(5,6),16)
                        h,s,v=Color3.fromRGB(r,g,b):ToHSV(); update(false)
                    else update(true) end
                end)
                on(click.Activated,function()
                    cancelTabAnimation(); local open=not popup.Visible
                    if dropClose then dropClose() end
                    if open then placePicker() end
                    popup.Visible=open; if open then dropClose=closePicker end
                end)
                local control={}
                function control:Set(value,alphaValue,silent)
                    h,s,v=value:ToHSV(); if alphaValue then opacity=math.clamp(alphaValue,0,1) end
                    update(silent)
                end
                function control:Get() return color,opacity end
                for _,object in ipairs(popup:GetDescendants()) do object:SetAttribute('CustomColor',true) end
                update(true); return register(sectionID..'/'..title,'Color',control)
            end
            function section:TextBox(title,default)
                local yy=reserve(43); text(panel,title,26,yy,252,15)
                local field=new('TextBox',{Position=UDim2.fromOffset(26,yy+18),Size=UDim2.fromOffset(252,19),BackgroundColor3=rgb(26),BorderSizePixel=0,Text=default or '',TextColor3=white,Font=Enum.Font.Code,TextSize=11,ClearTextOnFocus=false,TextXAlignment=Enum.TextXAlignment.Left},panel)
                border(field,rgb(0))
                return {Get=function() return field.Text end,Set=function(_,value) field.Text=tostring(value) end}
            end
            function section:Button(title,callback)
                local rowY=reserve(26)
                local b=hit(panel,26,rowY,252,20); b.BackgroundTransparency=0; b.BackgroundColor3=rgb(26); border(b,rgb(0))
                local t=text(b,title,0,0,252,20); t.TextXAlignment=Enum.TextXAlignment.Center
                on(b.Activated,function() call(callback) end); return b
            end
            function section:DisabledBanner()
                -- Clip the ribbon to the section. Floating popups use their own layer.
                panel.ClipsDescendants=true
                local cover=hit(panel,0,0,288,40)
                cover.Size=UDim2.fromScale(1,1); cover.ZIndex=15; cover.Selectable=false
                local ribbon=frame(cover,0,0,320,24,Color3.fromRGB(83,39,32))
                ribbon.AnchorPoint=Vector2.new(0.5,0.5); ribbon.Position=UDim2.fromScale(0.5,0.5)
                ribbon.BackgroundTransparency=0.12; ribbon.ZIndex=16
                local edge=frame(ribbon,0,0,320,1,Color3.fromRGB(216,111,75)); edge.ZIndex=17
                local label=text(ribbon,'DISABLED',0,0,320,24,Color3.fromRGB(245,179,142))
                label.Size=UDim2.fromScale(1,1); label.TextXAlignment=Enum.TextXAlignment.Center
                label.Font=Enum.Font.GothamBold; label.TextSize=11; label.ZIndex=17
                local function positionRibbon()
                    local width,height=panel.Size.X.Offset,panel.Size.Y.Offset
                    local length=math.sqrt(width*width+height*height)+32
                    ribbon.Size=UDim2.fromOffset(length,24)
                    ribbon.Rotation=math.deg(math.atan2(height,width))
                    edge.Size=UDim2.new(1,0,0,1)
                end
                on(panel:GetPropertyChangedSignal('Size'),positionRibbon)
                positionRibbon()
            end
            function section:Spacer(pixels)
                reserve(pixels or 12)
            end
            return section
        end
        return tab
    end
    function win:ConfigUI(section)
        local folder='Fanta/configs/'..tostring(game.PlaceId)
        local memory={}
        local disk=type(writefile)=='function' and type(readfile)=='function' and type(listfiles)=='function' and type(isfolder)=='function' and type(makefolder)=='function' and type(delfile)=='function'
        if disk then
            local ok=pcall(function()
                for _,path in ipairs({'Fanta','Fanta/configs',folder}) do if not isfolder(path) then makefolder(path) end end
            end)
            disk=ok
        end
        local nameField=section:TextBox('Name','default')
        local saved=section:Dropdown('Saved',{'—'},'—',nil,true)
        local status=section:Label(disk and '' or 'Session storage only')
        local function notify(message) status.Text=tr(message) end
        local function clean(name)
            name=tostring(name or ''):match('^%s*(.-)%s*$')
            if #name<1 or #name>48 or not name:match('^[%w _%-]+$') then error('Use 1–48 letters, numbers, spaces, underscores or hyphens.') end
            return name
        end
        local function refresh(preferred)
            local names={}
            if disk then
                for _,path in ipairs(listfiles(folder)) do
                    local name=path:gsub('\\','/'):match('/([^/]+)%.json$')
                    if name and pcall(clean,name) then table.insert(names,name) end
                end
            else for name in pairs(memory) do table.insert(names,name) end end
            table.sort(names,function(a,b) return a:lower()<b:lower() end)
            saved:SetOptions(names,preferred)
        end
        local function action(fn)
            return function()
                local ok,err=pcall(fn)
                if not ok then notify((tostring(err):gsub('^.-:%d+: ',''))) end
            end
        end
        section:Button('Save',action(function()
            local name=clean(nameField:Get())
            local state={Version=1,PlaceId=game.PlaceId,Controls={},Layout={Scale=requestedScale,XScale=root.Position.X.Scale,XOffset=root.Position.X.Offset,YScale=root.Position.Y.Scale,YOffset=root.Position.Y.Offset}}
            for id,entry in pairs(registry) do
                local value,alpha=entry.Control:Get()
                if entry.Kind=='Color' then value={R=value.R,G=value.G,B=value.B,Alpha=alpha or 1} end
                state.Controls[id]={Kind=entry.Kind,Value=value}
            end
            local json=HttpService:JSONEncode(state)
            if disk then writefile(folder..'/'..name..'.json',json) else memory[name]=json end
            refresh(name); notify('Saved')
        end))
        section:Button('Load',action(function()
            local name=clean(saved:Get())
            local raw=disk and readfile(folder..'/'..name..'.json') or memory[name]
            assert(type(raw)=='string' and #raw<=262144,'Invalid config size')
            local state=HttpService:JSONDecode(raw)
            assert(type(state)=='table' and state.Version==1 and state.PlaceId==game.PlaceId and type(state.Controls)=='table','Config is incompatible with this game')
            local function finite(n) return type(n)=='number' and n==n and math.abs(n)<10000000 end
            local function apply(id,entry,data)
                if type(data)~='table' or data.Kind~=entry.Kind then return end
                local value=data.Value
                if entry.Kind=='Toggle' and type(value)=='boolean' then entry.Control:Set(value)
                elseif entry.Kind=='Slider' and finite(value) then entry.Control:Set(value)
                elseif entry.Kind=='Dropdown' and type(value)=='string' then entry.Control:Set(value)
                elseif entry.Kind=='Keybind' and type(value)=='table' then entry.Control:Set(value)
                elseif entry.Kind=='Color' and type(value)=='table' and finite(value.R) and finite(value.G) and finite(value.B) then
                    entry.Control:Set(Color3.new(math.clamp(value.R,0,1),math.clamp(value.G,0,1),math.clamp(value.B,0,1)),finite(value.Alpha) and math.clamp(value.Alpha,0,1) or 1,false)
                end
            end
            -- Bind modes are restored last so Always/Hold remain consistent.
            for _,kind in ipairs({'Dropdown','Slider','Color','Toggle','Keybind'}) do
                for id,entry in pairs(registry) do if entry.Kind==kind and state.Controls[id] then apply(id,entry,state.Controls[id]) end end
            end
            local layout=state.Layout
            if type(layout)=='table' and finite(layout.Scale) then
                local view=workspace.CurrentCamera.ViewportSize
                requestedScale=math.clamp(layout.Scale,0.1,1.8)
                scale.Scale=math.min(requestedScale,(view.X-16)/756,(view.Y-16)/536)
                if finite(layout.XScale) and finite(layout.XOffset) and finite(layout.YScale) and finite(layout.YOffset) then
                    local x=layout.XScale*view.X+layout.XOffset; local y=layout.YScale*view.Y+layout.YOffset
                    root.Position=UDim2.fromOffset(math.clamp(x,756*scale.Scale/2,view.X-756*scale.Scale/2),math.clamp(y,536*scale.Scale/2,view.Y-536*scale.Scale/2))
                end
            end
            nameField:Set(name); notify('Loaded')
        end))
        section:Button('Delete',action(function()
            local name=clean(saved:Get())
            if disk then delfile(folder..'/'..name..'.json') else memory[name]=nil end
            refresh(); notify('Deleted')
        end))
        section:Button('Refresh',action(function() refresh(); notify('Refreshed') end))
        local ok,err=pcall(refresh); if not ok then notify(tostring(err)) end
    end
    function win:FinishLoading()
        local loading=new('CanvasGroup',{Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(320,115),BackgroundColor3=rgb(17),BorderSizePixel=0,ZIndex=100,GroupTransparency=0},gui)
        border(loading,rgb(48))
        local name=text(loading,'FANTA',18,14,284,36,Themes.Fanta.Accent)
        name.Font=Enum.Font.GothamBlack; name.TextSize=28; name.TextXAlignment=Enum.TextXAlignment.Center
        local status=text(loading,'Connecting to server...',18,51,284,19,grey); status.TextXAlignment=Enum.TextXAlignment.Center
        local track=frame(loading,25,87,270,3,rgb(38))
        local fill=frame(track,0,0,0,3,Themes.Fanta.Accent)
        for _,object in ipairs(loading:GetDescendants()) do if object:IsA('GuiObject') then object.ZIndex=101 end end
        local progress=TweenService:Create(fill,TweenInfo.new(7.8,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(270,3)})
        table.insert(tabTweens,progress); progress:Play()
        task.delay(3,function() if not dead then status.Text=tr('Loading interface...') end end)
        task.delay(7,function() if not dead then status.Text=tr('Ready') end end)
        task.delay(8,function()
            if dead then return end
            local fade=TweenService:Create(loading,TweenInfo.new(0.18),{GroupTransparency=1})
            table.insert(tabTweens,fade); fade:Play()
            task.delay(0.2,function()
                if dead then return end
                loading:Destroy()
                if requireKey() then
                    if dead then return end
                    root.Visible=true; overlay.Visible=true; win.Ready=true
                else win:Destroy() end
            end)
        end)
    end
    return win
end

-- REFERENCE DEMO: replace these with your own controls/callbacks.
local window=Library:Window({Title='Fanta',Subtitle='REALISTIC HOME DEFENSE'})
local aim=window:Tab('Aim')
local silent=aim:Section('Silent Aim')
local silentToggle=silent:Toggle('Silent Aim',false)
silentToggle:Keybind()
silent:Toggle('Team check',true)
silent:Toggle('Prediction',true)
silent:Toggle('Show FOV',true,function(enabled) window:SetFOVVisible(enabled) end)
silent:ColorPicker('FOV colour',Color3.new(1,1,1),function(color,opacity) window:SetFOVColor(color,opacity) end)
silent:Dropdown('Target part',{'Head','Torso','HumanoidRootPart'},'Head')
silent:Slider('FOV radius',0,600,160,1,' px',function(radius) window:SetFOVRadius(radius) end)
window:SetFOVRadius(160); window:SetFOVVisible(true)
silent:Slider('Max distance',0,3000,1500,1,' studs')
local wall=aim:Section('Shoot through walls (Disabled)','Right')
wall:DisabledBanner()
local wallToggle=wall:Toggle('Shoot through walls',false)
wallToggle:SetDisabled(true)
wall:Slider('Max thickness',0,32,8,1,' studs')
wall:Slider('Max surfaces',0,12,8,1,'')
window:Tab('ESP')
local weapons=window:Tab('Weapons Exploits')
local weaponOptions=weapons:Section('Weapons Exploits')
weaponOptions:Toggle('No Recoil',false)
weaponOptions:Toggle('Rapid Fire',false)
weaponOptions:Toggle('No Spread',false)
local settings=window:Tab('Settings')
local theme=settings:Section('Theme')
theme:Dropdown('Theme',{'Fanta','Halloween','Christmas'},'Fanta',function(name)
    window:SetTheme(name)
end)
local language=settings:Section('Language')
language:Dropdown('Language',LanguageOptions,'English',function(value) window:SetLanguage(value) end,true)
local config=settings:Section('Config','Right')
window:ConfigUI(config)
local info=settings:Section('Interface','Right')
info:Label('Home: show / hide')
info:Spacer(12)
info:Button('Unload',function() window:Destroy() end)
-- Reusable API:
-- local section = tab:Section('Title', 'Right')
-- section:Toggle('Name', false, function(enabled) print(enabled) end)
-- section:Slider('Amount', 0, 100, 50, 1, ' px', function(value) print(value) end)
-- section:Dropdown('Choice', {'One','Two'}, 'One', function(value) print(value) end)
-- Controls expose :Get() and :Set(value, silent).

window:SetTheme('Fanta')

window:FinishLoading()
