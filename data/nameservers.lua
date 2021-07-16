local _servers =
{
	{0,"202.134.87.4", "", "Diyixian.com Limited -  (HK)"},
	{0,"169.255.152.118", "", "ALBIDEYNET - Bongor (TD)"},
	{0,"89.221.2.168", "", "net-and-phone GmbH - Essen (DE)"},
	{0,"122.155.6.206", "", "CAT Telecom Public Company Limited -  (TH)"},
	{0,"5.83.92.254", "84.236.142.130", "ServiHosting Networks S.L. - Morón de la Frontera (ES)"},
	{0,"193.183.98.66", "", "Prometeus di Daniela Agro - Milan (IT)"},
	{0,"89.233.43.71", "195.67.27.18", "Telia Company AB - Kobenhavn O (DK)"},
	{0,"103.203.133.66", "", "Myanmar Country Co. Ltd. -  (MM)"},
	{0,"195.186.4.192", "195.186.4.111", "Bluewin -  (CH)"},
	{0,"103.116.159.150", "", "Bee Connect Myanmar Co. Ltd. -  (MM)"},
	{0,"176.103.130.130", "176.103.130.137", "Serveroid LLC -  (RU)"},
	{0,"69.63.73.141", "", "SWAZINET -  (SZ)"},
	{0,"186.120.184.35", "", "ALTICE DOMINICANA S.A. - Santo Domingo Este (DO)"},
	{0,"212.66.129.98", "", "NetAachen GmbH - Düren (DE)"},
	{0,"200.10.231.190", "", "Centro Nacional de Computacion -  (PY)"},
	{0,"80.179.155.145", "", "Partner Communications Ltd. -  (IL)"},
	{0,"194.60.210.66", "", "Farzanegan Pars Communications Company PJS -  (IR)"},
	{0,"202.158.49.188", "", "PT Cyberindo Aditama - Jakarta (ID)"},
	{0,"153.19.105.120", "", "Technical University of Gdansk Academic Computer Center TASK - Racibórz (PL)"},
	{0,"207.188.83.213", "", "PATHWAY - Whitby (CA)"},
	{0,"212.236.250.4", "", "Video-Broadcast GmbH -  (AT)"},
	{0,"94.158.96.2", "", "OOO Scientific-Production Enterprise Edma - Moscow (RU)"},
	{0,"103.232.35.101", "", "GTT Netherlands B.V. -  (HK)"},
	{0,"52.3.100.184", "", "AMAZON-AES - Ashburn (US)"},
	{0,"181.14.245.186", "200.45.184.43", "Telecom Argentina S.A. - Victoria (AR)"},
	{0,"194.25.0.60", "62.225.102.177", "Deutsche Telekom AG - Vohringen (DE)"},
	{0,"204.193.157.30", "", "QTS-SUW1-ATL1 - Woodstock (US)"},
	{0,"82.141.171.84", "62.77.202.25", "Invitech ICT Services Kft. - Hajduszoboszlo (HU)"},
	{0,"109.70.132.17", "", "Propelin Consulting S.L.U. -  (ES)"},
	{0,"82.151.69.146", "", "MAURITEL - Tevragh Zeina (MR)"},
	{0,"198.54.117.10", "", "NAMECHEAP-NET -  (US)"},
	{0,"202.215.204.171", "", "ARTERIA Networks Corporation - Osaka (JP)"},
	{0,"85.214.151.164", "", "Strato AG -  (DE)"},
	{0,"190.108.85.3", "", "INTERNEXA PERU S.A - Lima (PE)"},
	{0,"91.186.192.3", "", "Raya Sepehr Vira Data Processing Company Ltd. -  (IR)"},
	{0,"195.110.24.248", "", "State Fund Agriculture - Sofia (BG)"},
	{0,"85.132.32.41", "", "CASPEL LLC - Baku (AZ)"},
	{0,"103.123.108.188", "", "Universitas Negeri Manado -  (ID)"},
	{0,"200.105.253.170", "", "PUNTONET S.A. - Quito (EC)"},
	{0,"188.118.227.21", "", "Hutchison Drei Austria GmbH - Vienna (AT)"},
	{0,"66.96.229.59", "", "PT. Eka Mas Republik - Depok (ID)"},
	{0,"87.23.196.161", "62.86.183.222", "Telecom Italia - Castiglione (IT)"},
	{0,"64.238.96.12", "", "ATL-CBEYOND - Atlanta (US)"},
	{0,"212.234.19.21", "", "Orange - Sainte-Gemme-la-Plaine (FR)"},
	{0,"160.119.209.148", "", "Touch-IT-AS - Mbabane (SZ)"},
	{0,"200.169.96.10", "200.169.96.11", "UOL DIVEO S.A. -  (BR)"},
	{0,"2.228.121.163", "83.103.36.213", "Fastweb - Rimini (IT)"},
	{0,"204.194.232.200", "204.194.234.200", "302-DIRECT-MEDIA-ASN -  (US)"},
	{0,"86.107.249.193", "", "Ambra SRL - Piatra Neamţ (RO)"},
	{0,"213.184.224.254", "", "Unitary enterprise A1 - Minsk (BY)"},
	{0,"84.8.2.11", "", "alwaysON Limited -  (GB)"},
	{0,"194.67.49.242", "212.46.234.217", "PVimpelCom - Moscow (RU)"},
	{0,"208.106.131.31", "", "CENTURYLINK-LEGACY-LVLT-203 -  (US)"},
	{0,"185.242.177.8", "", "LINZ STROM GAS WAERME GmbH fuer Energiedienstleistungen und Telekommunikation -  (AT)"},
	{0,"131.100.36.162", "", "Digicel Trinidad and Tobago Ltd. - Port of Spain (TT)"},
	{0,"154.73.209.69", "", "RMS-Powertronics - Johannesburg (ZA)"},
	{0,"131.196.220.10", "", "MELNET PROVEDOR - Porto Alegre (BR)"},
	{0,"216.228.104.3", "98.101.120.225", "TWC-11426-CAROLINAS -  (US)"},
	{0,"85.255.157.162", "", "Gamsjaeger Kabel-TV & ISP Betriebs GmbH - Ybbs an der Donau (AT)"},
	{0,"202.44.53.251", "", "Internet Service Provider -  (TH)"},
	{0,"123.30.184.132", "", "VNPT Corp -  (VN)"},
	{0,"85.132.85.85", "", "Delta Telecom Ltd -  (AZ)"},
	{0,"202.51.111.149", "", "PT iForte Global Internet - Jakarta (ID)"},
	{0,"37.235.1.174", "37.235.1.177", "ANEXIA Internetdienstleistungs GmbH -  (AT)"},
	{0,"193.230.183.201", "", "Euroweb Romania S.R.L. -  (RO)"},
	{0,"94.247.43.254", "", "Lennart Seitz -  (DE)"},
	{0,"216.173.178.83", "", "ELECTRONET - Tallahassee (US)"},
	{0,"194.247.190.70", "", "Proxima Ltd - Ramenskoye (RU)"},
	{0,"31.24.234.37", "", "Tehran Municipality ICT Organization -  (IR)"},
	{0,"202.222.192.35", "", "Hitachi Cloud services Division -  (JP)"},
	{0,"180.180.247.42", "", "Internet Data Center Service -  (TH)"},
	{0,"171.25.229.166", "", "Cobalt Group BV -  (BE)"},
	{0,"43.229.62.192", "", "Mammoth Media Pty Ltd - Macquarie Park (AU)"},
	{0,"46.16.229.223", "", "JSC Elektrosvyaz - Kasumkent (RU)"},
	{0,"178.22.113.198", "", "Sprintel s.r.o. - Prostějov (CZ)"},
	{0,"64.94.1.33", "", "INTERNAP-BLOCK-4 - Atlanta (US)"},
	{0,"216.104.206.136", "", "Africa Online Uganda - Kampala (UG)"},
	{0,"193.183.18.21", "", "Atea A/S -  (SE)"},
	{0,"202.56.128.30", "", "T-SYSTEMS SINGAPORE PTE LTD - Singapore (SG)"},
	{0,"154.72.202.86", "154.72.197.138", "NITA -  (UG)"},
	{0,"46.231.210.26", "", "OBIT Ltd. - Moscow (RU)"},
	{0,"62.149.132.2", "", "Aruba S.p.A. - Arezzo (IT)"},
	{0,"196.3.132.153", "", "Telecommunication Services of Trinidad and Tobago -  (TT)"},
	{0,"159.192.137.80", "", "CAT TELECOM Public Company LtdCAT -  (TH)"},
	{0,"187.120.48.47", "", "RRM SERVICOS DE INFORMATICA LTDA - Sobral (BR)"},
	{0,"202.46.34.74", "", "ShenZhen Sunrise Technology Co.Ltd. - Guangzhou (CN)"},
	{0,"217.19.153.3", "", "Reti Telematiche Italiane S.p.A. (Retelit S.p.A.) - Milan (IT)"},
	{0,"203.250.129.214", "203.250.129.215", "PAICHAI UNIVERSITY -  (KR)"},
	{0,"199.2.252.10", "", "SPRINTLINK -  (US)"},
	{0,"200.56.224.11", "", "Marcatel Com S.A. de C.V. -  (MX)"},
	{0,"31.47.196.211", "45.133.105.123", "GNC-Alfa CJSC - Yerevan (AM)"},
	{0,"80.228.63.124", "", "EWE-Tel GmbH - Wilhelmshaven (DE)"},
	{0,"207.59.153.242", "209.252.188.104", "WINDSTREAM - Baltimore (US)"},
	{0,"212.36.64.16", "212.36.64.17", "OGIC Informatica S.L. - Barcelona (ES)"},
	{0,"202.58.198.158", "", "Internet Madju Abad Millenindo PT - Samarinda (ID)"},
	{0,"84.16.240.43", "", "Leaseweb Deutschland GmbH -  (DE)"},
	{0,"189.126.192.4", "", "Vogel Solucoes em Telecom e Informatica S/A - Sao Vicente (BR)"},
	{0,"209.191.129.65", "", "INTERNAP-BLK -  (US)"},
	{0,"69.67.97.18", "", "TELENET-INTL - Littleton (US)"},
	{0,"46.10.205.252", "", "Vivacom - Sofia (BG)"},
	{0,"176.221.23.252", "", "Andishe Sabz Khazar Co. P.j.s. -  (IR)"},
	{0,"91.200.227.141", "", "Korporatsia Svyazy Ltd. - Reutov (RU)"},
	{0,"212.89.130.180", "", "InfoServe GmbH - Quierschied (DE)"},
	{0,"212.237.125.216", "", "Kurdistan Net Company for Computer and Internet Ltd. - Erbil (IQ)"},
	{0,"216.17.128.2", "", "FRII - Fort Collins (US)"},
	{0,"62.140.239.1", "", "LLC trc Fiord - Kyiv (UA)"},
	{0,"60.244.115.166", "124.219.29.129", "Asia Pacific Broadband Fixed Lines Co. Ltd. - Hsinchu (TW)"},
	{0,"46.173.34.32", "", "Gorset Ltd. - Tver (RU)"},
	{0,"217.12.181.97", "109.168.43.86", "Irideos S.p.A. - Costabissara (IT)"},
	{0,"24.229.250.113", "", "AS-PTD - Bethlehem (US)"},
	{0,"201.222.48.206", "201.222.55.246", "TECNOLOGIA EN ELECTRONICA E INFORMATICA SOCIEDAD ANONIMA (T.E.I.S.A) - Asunción (PY)"},
	{0,"83.149.227.152", "", "Federal State Institution Federal Scientific Research Institute for System Analysis of the Ru - Moscow (RU)"},
	{0,"80.83.162.11", "", "Digital Telco s.r.l. - Putignano (IT)"},
	{0,"45.33.97.5", "172.104.59.35", "Linode LLC - Atlanta (US)"},
	{0,"79.141.82.250", "", "NTD SA -  (CH)"},
	{0,"185.23.131.73", "", "Razavi Information and communication technology company Plc -  (IR)"},
	{0,"205.242.187.234", "", "CDM -  (US)"},
	{0,"83.170.202.226", "", "Kyivstar PJSC -  (UA)"},
	{0,"202.44.80.25", "", "My Solutions Corporation Ltd. -  (PK)"},
	{0,"170.239.144.20", "", "JARBAS PASCHOAL BRAZIL JUNIOR INFORMATICA - Olinda (BR)"},
	{0,"203.189.89.15", "", "Departemen Energi dan Sumber Daya Mineral - Bandung (ID)"},
	{0,"69.24.197.9", "", "OSNET - Corozal (PR)"},
	{0,"212.211.132.4", "", "ScanPlus GmbH - Düsseldorf (DE)"},
	{0,"216.66.104.72", "", "VERMONT-TELE - South Woodstock (US)"},
	{0,"144.76.83.104", "5.9.172.92", "Hetzner Online GmbH -  (DE)"},
	{0,"179.60.235.209", "", "WICORP SA -  (AR)"},
	{0,"180.76.76.76", "", "Beijing Baidu Netcom Science and Technology Co. Ltd. -  (CN)"},
	{0,"190.122.186.214", "", "CABLECOLOR S.A. - Morales (GT)"},
	{0,"109.71.42.228", "", "Almouroltec Servicos De Informatica E Internet Lda - Lisbon (PT)"},
	{0,"217.77.71.1", "", "Gabon-Telecom - Libreville (GA)"},
	{0,"193.89.248.1", "80.199.45.70", "Tele Danmark - Copenhagen (DK)"},
	{0,"65.48.229.96", "", "COLUMBUS-COMMUNICATION-SVG - Questelles (VC)"},
	{0,"69.16.132.4", "", "StackPath LLC -  (US)"},
	{0,"89.234.141.66", "", "Association Alsace Reseau Neutre - Strasbourg (FR)"},
	{0,"182.93.14.178", "202.86.191.50", "Companhia de Telecomunicacoes de Macau SARL - Macao (MO)"},
	{0,"92.247.24.30", "", "A1 Bulgaria EAD - Sofia (BG)"},
	{0,"45.248.197.53", "", "MYREPUBLIC PTY LTD -  (AU)"},
	{0,"195.202.147.102", "", "kabelplus GmbH - Sankt Pölten (AT)"},
	{0,"203.146.237.237", "", "CS LOXINFO PUBLIC COMPANY LIMITED - Bangkok (TH)"},
	{0,"203.229.206.20", "", "THE CATHOLIC UNIVERSITY OF KOREA SONGSIM - Seoul (KR)"},
	{0,"200.69.193.2", "", "NSS S.A. - Buenos Aires (AR)"},
	{0,"189.113.132.101", "", "TELECALL TELECOMUNICACOES - Rio de Janeiro (BR)"},
	{0,"213.211.50.1", "", "itself s.r.o. - Kostelec nad Orlici (CZ)"},
	{0,"176.110.8.17", "5.58.74.133", "Lanet Network Ltd - Syeverodonets'k (UA)"},
	{0,"216.183.90.190", "204.187.78.254", "ROGERS-COMMUNICATIONS - Brampton (CA)"},
	{0,"62.76.76.62", "", "Joint-stock company Internet Exchange MSK-IX -  (RU)"},
	{0,"202.174.158.10", "", "SPEEDCAST Limited -  (HK)"},
	{0,"185.112.147.95", "", "1984 ehf -  (IS)"},
	{0,"216.106.1.3", "216.106.1.254", "SOCKET - Columbia (US)"},
	{0,"89.17.194.43", "", "acens Technologies S.L. - Zaragoza (ES)"},
	{0,"113.196.55.130", "", "New Century InfoComm Tech Co. Ltd. - New Taipei (TW)"},
	{0,"89.113.0.68", "", "Public Joint Stock Company Vimpel-Communications -  (RU)"},
	{0,"185.51.200.2", "185.51.200.10", "Sefroyek Pardaz Engineering Co. LTD -  (IR)"},
	{0,"103.123.226.10", "", "Juweriyah Networks Private Limited - Mumbai (IN)"},
	{0,"130.225.244.166", "130.226.161.34", "Danish network for Research and Education - Copenhagen (DK)"},
	{0,"138.78.49.150", "", "SMCM -  (US)"},
	{0,"144.216.1.1", "", "NU-AS - Grand Island (US)"},
	{0,"94.176.233.93", "", "UAB Rakrejus - Vilnius (LT)"},
	{0,"186.229.50.2", "", "TIM S/A - Fortaleza (BR)"},
	{0,"109.70.207.80", "", "LA Wireless Srl - Como (IT)"},
	{0,"89.235.136.61", "", "MSN Telecom LLC -  (RU)"},
	{0,"123.193.34.20", "", "Taiwan Fixed Network Telco and Network Service Provider. - Taipei (TW)"},
	{0,"43.227.12.72", "", "Myanmar Unilink Communication Company Limited -  (MM)"},
	{0,"216.254.141.2", "", "PRIMUS-AS6407 - Verret (CA)"},
	{0,"216.240.32.72", "216.240.32.74", "AERIONET-INC - Los Angeles (US)"},
	{0,"186.193.207.158", "", "Byteweb Comunicacao Multimidia Ltda. - Santa Barbara d'Oeste (BR)"},
	{0,"194.27.192.5", "", "Galatasaray Universitesi -  (TR)"},
	{0,"192.169.192.162", "", "AS-26496-GO-DADDY-COM-LLC -  (US)"},
	{0,"5.145.112.38", "5.145.112.39", "E-Money Net Developers 24 Company Private Joint Stock -  (IR)"},
	{0,"66.199.45.225", "", "CDSI - Toronto (CA)"},
	{0,"119.235.21.188", "", "PT. Inet Global Indo - Jakarta (ID)"},
	{0,"200.87.195.70", "", "Entel S.A. - EntelNet -  (BO)"},
	{0,"202.43.162.242", "202.43.162.37", "DTPNET NAP - Banten (ID)"},
	{0,"217.112.27.34", "", "PJSC Moscow city telephone network - Moscow (RU)"},
	{0,"108.179.34.214", "", "CABLE-NET-1 - The Bronx (US)"},
	{0,"31.24.200.4", "", "Pars Fonoun Ofogh Information Technology and Communications Company LTD - Tehran (IR)"},
	{0,"216.21.128.22", "216.21.129.22", "RADIANT-VANCOUVER - Richmond (CA)"},
	{0,"194.168.4.123", "", "Virgin Media Limited - Solihull (GB)"},
	{0,"94.140.15.15", "94.140.14.140", "AdGuard Software Limited -  (CY)"},
	{0,"221.154.98.205", "211.221.79.4", "Korea Telecom - Bupyeong-gu (KR)"},
	{0,"188.227.240.58", "", "Blaze Networks Ltd - London (GB)"},
	{0,"186.38.56.11", "", "SCDPLANET S.A. - Salto (AR)"},
	{0,"69.28.104.5", "", "CCDT-AS -  (US)"},
	{0,"204.13.152.3", "", "MULTA-ASN1 -  (US)"},
	{0,"69.169.190.211", "", "OFF-CAMPUS-TELECOMMUNICATIONS - Payson (US)"},
	{0,"194.150.168.168", "", "AS250.net Foundation -  (DE)"},
	{0,"93.115.24.205", "", "UAB Cherry Servers -  (LT)"},
	{0,"27.123.22.82", "", "Fusion Networks - Auckland (NZ)"},
	{0,"212.43.98.12", "", "Micso Srl - Atri (IT)"},
	{0,"103.23.22.143", "43.245.180.22", "PT Infinys System Indonesia -  (ID)"},
	{0,"216.183.209.226", "216.183.210.18", "Ooredoo Maldives Plc -  (MV)"},
	{0,"81.1.217.134", "", "JSC Zap-Sib TransTeleCom Novosibirsk - Novosibirsk (RU)"},
	{0,"89.106.109.235", "", "Unics EOOD - Gabrovo (BG)"},
	{0,"210.180.98.69", "221.143.46.198", "SK Broadband Co Ltd - Gangseo-gu (KR)"},
	{0,"69.60.160.196", "69.60.160.203", "AMERICA - Gordon (US)"},
	{0,"24.113.32.29", "24.113.32.30", "AS-WAVE-1 - Port Orchard (US)"},
	{0,"80.78.132.79", "", "SkyLink Data Center BV -  (DE)"},
	{0,"195.69.65.98", "", "BILLING SOLUTION Ltd. -  (RU)"},
	{0,"62.91.19.67", "", "Bisping & Bisping GmbH & Co KG - Happurg (DE)"},
	{0,"190.105.152.28", "", "COMUNICACIONES TASION -  (PA)"},
	{0,"79.143.180.116", "", "Contabo GmbH - Munich (DE)"},
	{0,"194.219.110.187", "", "Forthnet - Athens (GR)"},
	{0,"66.18.240.197", "", "NUCLEUS-INC - Calgary (CA)"},
	{0,"197.189.234.82", "", "xneelo -  (ZA)"},
	{0,"158.43.128.72", "194.98.65.65", "UUNET -  (GB)"},
	{0,"213.5.120.2", "", "Andrey Chuenkov PE - Shumerlya (RU)"},
	{0,"74.120.24.129", "74.120.24.97", "IP-SOLUTIONS - Manati (PR)"},
	{0,"151.115.56.180", "", "Online S.a.s. - Warsaw (PL)"},
	{0,"185.82.126.226", "", "Sia Nano IT -  (LV)"},
	{0,"213.30.88.178", "", "Vodafone Portugal - Communicacoes Pessoais S.A. - Lisbon (PT)"},
	{0,"62.2.174.133", "62.2.121.88", "Liberty Global B.V. - Biel/Bienne (CH)"},
	{0,"103.23.150.89", "", "4th Floor New Administrative Building -  (IN)"},
	{0,"189.113.75.5", "", "SUMICITY TELECOMUNICACOES S.A. - Petrópolis (BR)"},
	{0,"203.239.130.3", "", "ELIMNET INC. -  (KR)"},
	{0,"200.58.72.78", "", "Comteco Ltda -  (BO)"},
	{0,"177.43.35.247", "187.75.155.116", "TELEFONICA BRASIL S.A - Curitiba (BR)"},
	{0,"86.58.179.6", "", "Sentia Denmark A/S - Naerum (DK)"},
	{0,"193.109.160.177", "", "Online Technologies LTD - Makiyivka (UA)"},
	{0,"195.138.74.246", "", "TENET Scientific Production Enterprise LLC - Odessa (UA)"},
	{0,"103.154.241.252", "", "Myanmar Link Telecommunication Ltd - Yangon (MM)"},
	{0,"206.74.254.2", "", "SPIRITTEL-AS - Johnsonville (US)"},
	{0,"177.200.48.48", "", "Pertec Servicos de Telecomunicacoes ltda - Rio de Janeiro (BR)"},
	{0,"77.42.130.37", "", "Libantelecom - Beirut (LB)"},
	{0,"200.220.192.86", "", "INTERNEXA BRASIL OPERADORA DE TELECOMUNICACOES S.A - Niterói (BR)"},
	{0,"82.146.26.2", "", "Medicom Bulgaria Ood - Sofia (BG)"},
	{0,"91.239.100.100", "", "Thomas Steen Rasmussen -  (DK)"},
	{0,"177.184.131.180", "186.225.45.138", "SOBRALNET SERVICOS E TELECOMUNICACOES LTDA - ME - Magalhaes de Almeida (BR)"},
	{0,"93.91.140.127", "", "Mynet S.r.l. - Commessaggio (IT)"},
	{0,"63.105.204.164", "", "KINX -  (US)"},
	{0,"156.154.70.1", "156.154.70.25", "NEUSTAR-AS6 -  (US)"},
	{0,"62.244.95.208", "", "BLUEGIX -  (FR)"},
	{0,"64.128.251.228", "", "NCN -  (US)"},
	{0,"5.2.75.75", "", "The Infrastructure Group B.V. -  (NL)"},
	{0,"182.19.95.34", "", "Vodafone Idea Ltd -  (IN)"},
	{0,"91.185.6.10", "", "JSC Transtelecom - Nur-Sultan (KZ)"},
	{0,"62.82.213.91", "62.81.238.230", "Vodafone Ono S.A. -  (ES)"},
	{0,"152.101.4.130", "203.85.45.131", "CITIC Telecom International CPC Limited -  (HK)"},
	{0,"105.96.43.54", "193.251.169.83", "Telecom Algeria - Annaba (DZ)"},
	{0,"203.119.36.106", "", "Vietnam Internet Network Information Center -  (VN)"},
	{0,"193.19.64.88", "", "Itera Norge AS -  (NO)"},
	{0,"202.138.120.6", "202.138.120.86", "Reliance Communications Ltd.DAKC MUMBAI -  (IN)"},
	{0,"59.148.213.230", "203.186.217.188", "Hong Kong Broadband Network Ltd. - Central (HK)"},
	{0,"185.107.80.84", "", "NForce Entertainment B.V. - Pijnacker (NL)"},
	{0,"45.90.28.193", "45.90.28.203", "nextdns Inc. -  (US)"},
	{0,"186.251.226.252", "", "STARNET TELECOMUNICACOES LTDA - Piracaia (BR)"},
	{0,"211.237.65.21", "", "SKTelink -  (KR)"},
	{0,"216.165.129.158", "", "TDS-AS - Madison (US)"},
	{0,"62.212.113.125", "", "Nerim SAS - Cruseilles (FR)"},
	{0,"199.255.137.34", "", "DACEN-2 -  (US)"},
	{0,"185.38.27.139", "", "Kracon ApS -  (DK)"},
	{0,"87.213.100.113", "", "T-mobile Netherlands B.V. - Amersfoort (NL)"},
	{0,"76.72.248.34", "", "NEPTUNO-NET - Trujillo Alto (PR)"},
	{0,"121.254.134.99", "106.240.228.50", "LG DACOM Corporation -  (KR)"},
	{0,"162.243.19.47", "104.131.37.180", "DIGITALOCEAN-ASN - New York (US)"},
	{0,"81.180.117.110", "", "Digital Cable Systems S.A. - Bucharest (RO)"},
	{0,"165.16.68.1", "", "Aljeel-net -  (LY)"},
	{0,"83.145.86.7", "", "Completel SAS - Lille (FR)"},
	{0,"45.250.253.222", "", "New Generation Internet Services Limited -  (BD)"},
	{0,"177.131.114.86", "", "ACESSOLINE TELECOMUNICACOES LTDA - Chapecó (BR)"},
	{0,"200.57.2.108", "", "Operbes S.A. de C.V. - Ecatepec (MX)"},
	{0,"138.36.1.14", "", "TEX NET SERVICOS DE COMUNICACAO EM INFORMATICA LTD - Fortaleza (BR)"},
	{0,"219.252.1.100", "219.252.2.100", "SK Telecom - Gwanak-gu (KR)"},
	{0,"165.246.10.2", "", "INHA UNIVERSITY -  (KR)"},
	{0,"89.211.53.228", "78.100.99.171", "Ooredoo Q.S.C. - Doha (QA)"},
	{0,"210.60.147.4", "", "Taiwan Academic Network (TANet) Information Center -  (TW)"},
	{0,"130.185.242.224", "", "Optinet Ltd - Yambol (BG)"},
	{0,"200.105.133.162", "", "AXS Bolivia S. A. - La Paz (BO)"},
	{0,"81.163.3.1", "", "Rasana Pishtaz Iranian Service Cooperative Co. -  (IR)"},
	{0,"24.181.107.227", "24.181.107.229", "CHARTER-20115 - Montgomery (US)"},
	{0,"180.94.94.195", "", "AFGHANTELECOM GOVERNMENT COMMUNICATION NETWORK -  (AF)"},
	{0,"195.46.39.39", "", "SafeDNS Inc. -  ()"},
	{0,"216.146.35.35", "", "DYNDNS -  (US)"},
	{0,"212.30.220.133", "", "Siminn - Grindavik (IS)"},
	{0,"188.252.69.3", "", "GETRESPONSE Sp.z o.o. - Gdansk (PL)"},
	{0,"80.254.77.39", "", "Monzoon Networks AG - Biel/Bienne (CH)"},
	{0,"88.80.64.8", "", "Archimedia SRL -  (IT)"},
	{0,"109.7.126.78", "109.2.249.42", "SFR SA - Corbeil-Essonnes (FR)"},
	{0,"193.231.236.25", "", "RCS & RDS -  (RO)"},
	{0,"187.6.84.178", "", "Brasil Telecom S/A - Filial Distrito Federal - Corumbá (BR)"},
	{0,"195.189.150.37", "", "Iristel Romania Srl -  (RO)"},
	{0,"31.129.186.43", "", "TOV Magnus Limited - Bila Tserkva (UA)"},
	{0,"185.184.222.222", "", "XTOM -  (AU)"},
	{0,"196.13.158.51", "196.13.141.10", "DENINF-IPLAN -  (ZA)"},
	{0,"138.97.84.3", "", "INTERLES COMUNICACOES LTDA - Aracruz (BR)"},
	{0,"193.110.60.3", "", "DIGI Tavkozlesi es Szolgaltato Kft. - Budapest (HU)"},
	{0,"46.20.67.50", "91.205.3.65", "Joint Stock Company TransTeleCom - Samara (RU)"},
	{0,"213.244.72.31", "", "Palestine Telecommunications Company (PALTEL) -  (PS)"},
	{0,"176.103.66.101", "193.200.69.242", "FOP Makurin Stanislav Volodimirovich - Kyiv (UA)"},
	{0,"81.83.28.206", "", "Telenet BVBA - Ghent (BE)"},
	{0,"92.38.152.163", "92.223.65.71", "G-Core Labs S.A. - Moscow (RU)"},
	{0,"37.57.130.244", "178.150.45.81", "Content Delivery Network Ltd - Kharkiv (UA)"},
	{0,"89.236.217.93", "", "ist Telekom LLC - Tashkent (UZ)"},
	{0,"211.72.210.250", "60.248.139.169", "Data Communication Business Group - New Taipei (TW)"},
	{0,"114.130.5.5", "114.130.5.6", "Tire-1 IP Transit Provider of Bangladesh -  (BD)"},
	{0,"164.163.1.90", "", "connectx servicos de telecomunicacoes ltda - Brasília (BR)"},
	{0,"213.136.192.2", "", "SUHUF Internet Services -  (SA)"},
	{0,"78.156.159.132", "", "OptoNet Communication spol. s.r.o. - Jihlava (CZ)"},
	{0,"45.67.219.208", "185.213.26.187", "HOSTHATCH - Los Angeles (US)"},
	{0,"103.86.96.100", "103.86.99.100", "TEFINCOM S.A. - Sydney (AU)"},
	{0,"59.188.74.1", "123.1.150.121", "AS number for New World Telephone Ltd. -  (HK)"},
	{0,"165.87.13.129", "12.127.17.72", "ATT-INTERNET4 -  (US)"},
	{0,"186.194.224.82", "", "R&R PROVEDOR DE INTERNET LTDA - Presidente Prudente (BR)"},
	{0,"179.109.15.42", "", "FamaNet Tecnologia e Informatica LTDA - Alegre (BR)"},
	{0,"195.162.8.154", "", "Telecom Plus Ltd. -  (RU)"},
	{0,"202.87.249.2", "202.87.249.5", "PT. Andalas Media Informatika - Jakarta (ID)"},
	{0,"103.198.131.226", "", "PT Bina Informasi Optima Solusindo -  (ID)"},
	{0,"82.70.88.14", "", "Zen Internet Ltd - Kettering (GB)"},
	{0,"93.91.145.230", "", "ISP Alliance a.s. - Chomutov (CZ)"},
	{0,"192.133.129.2", "", "RITTERNET - Searcy (US)"},
	{0,"168.187.46.242", "", "KW KEMS Block-A Safat 130 -  (KW)"},
	{0,"162.247.147.98", "", "LAKENET-LLC - Hemlock (US)"},
	{0,"200.185.113.202", "", "TIVIT TERCEIRIZACAO DE PROCESSOS SERV. E TEC. S/A - Rio de Janeiro (BR)"},
	{0,"203.8.201.10", "", "Jagran Building -  (IN)"},
	{0,"210.87.250.59", "218.102.23.228", "HKT Limited -  (HK)"},
	{0,"82.99.242.155", "", "Pars Online PJS -  (IR)"},
	{0,"105.30.247.93", "", "SEACOM-AS - Durban (ZA)"},
	{0,"194.187.251.67", "194.145.241.6", "M247 Ltd - Manchester (GB)"},
	{0,"80.66.120.34", "", "Valor Information Technologies S.L. - Torrevieja (ES)"},
	{0,"95.142.83.43", "", "CJSC Telecomm Technology -  (TJ)"},
	{0,"66.181.167.232", "", "first E-commerce and TriplePlay Service ISP in Mongolia. - Ulan Bator (MN)"},
	{0,"118.189.211.221", "", "MobileOne Ltd. Mobile/Internet Service Provider Singapore - Singapore (SG)"},
	{0,"185.55.225.25", "185.55.226.26", "Fanavari Serverpars Argham Gostar Company Ltd. -  (IR)"},
	{0,"200.110.130.195", "200.110.130.194", "IFX18747 - Buenos Aires (AR)"},
	{0,"154.32.107.18", "154.32.109.18", "Telstra Global -  (GB)"},
	{0,"76.76.2.0", "76.76.2.3", "CONTROLD -  (CA)"},
	{0,"212.100.143.211", "", "OJSC Comcor - Moscow (RU)"},
	{0,"114.4.110.164", "", "INDOSAT Internet Network Provider -  (ID)"},
	{0,"68.87.68.162", "70.90.140.130", "COMCAST-7922 - Atlanta (US)"},
	{0,"195.204.130.85", "", "Globalconnect As - Kviteseid (NO)"},
	{0,"84.51.27.194", "", "Tellcom Iletisim Hizmetleri A.s. -  (TR)"},
	{0,"190.109.224.227", "", "Cotel Ltda. - La Paz (BO)"},
	{0,"190.211.104.93", "", "Cooperativa de Electrificacion Rural de San Carlos R.L. (Coopelesca R.L.) - Pital (CR)"},
	{0,"91.200.116.21", "", "Instal Matel Sl - Asteasu (ES)"},
	{0,"199.85.126.10", "64.6.65.6", "ULTRADNS -  (US)"},
	{0,"196.15.170.131", "", "SAIX-NET - Secunda (ZA)"},
	{0,"139.130.4.4", "139.134.5.51", "Telstra Corporation Ltd - Balwyn North (AU)"},
	{0,"78.159.43.189", "", "Freenet LTD - Kyiv (UA)"},
	{0,"197.248.116.74", "", "Safaricom - Nairobi (KE)"},
	{0,"158.193.86.29", "", "Zdruzenie pouzivatelov Slovenskej akademickej datovej siete - Svidník (SK)"},
	{0,"201.144.94.245", "", "Uninet S.A. de C.V. - Iztapalapa (MX)"},
	{0,"212.118.241.33", "", "InterNAP Network Services U.K. Limited - Lambeth (GB)"},
	{0,"124.6.169.35", "124.6.188.203", "Globe Telecom Inc. - City of Muntinglupa (PH)"},
	{0,"186.251.103.10", "186.251.103.3", "Acesse Facil Telecomunicacoes Ltda - Coronel Fabriciano (BR)"},
	{0,"177.92.0.90", "200.195.154.122", "COPEL Telecomunicacoes S.A. - Curitiba (BR)"},
	{0,"204.152.204.10", "", "ASN-QUADRANET-GLOBAL - Los Angeles (US)"},
	{0,"186.56.59.251", "", "Cotelvo Ltda. -  (AR)"},
	{0,"202.147.193.108", "", "PT. MNC Kabel Mediacom - Jakarta (ID)"},
	{0,"103.3.75.90", "103.3.75.102", "Block B05/3 Garden City Business Centre - Petaling Jaya (MY)"},
	{0,"203.73.77.205", "210.66.135.117", "Digital United Inc. - Taoyuan District (TW)"},
	{0,"113.59.228.125", "", "Kawaguchiko cable television Inc - Yamanashi (JP)"},
	{0,"37.111.49.182", "", "Telenor Myanmar -  (MM)"},
	{0,"109.123.19.5", "", "BBTEL d.o.o. - Vuzenica (SI)"},
	{0,"62.97.123.107", "62.97.123.106", "COLT Technology Services Group Limited - Madrid (ES)"},
	{0,"82.96.65.2", "", "Probe Networks -  (DE)"},
	{0,"175.103.48.7", "", "PT. Maxindo Content Solution -  (ID)"},
	{0,"5.200.200.200", "78.38.117.206", "Iran Telecommunication Company PJS -  (IR)"},
	{0,"212.85.112.32", "", "home.pl S.A. -  (PL)"},
	{0,"65.111.169.164", "65.111.169.159", "INFOLINK-MIA -  (US)"},
	{0,"91.112.103.26", "", "A1 Telekom Austria AG - Ladis (AT)"},
	{0,"217.18.206.22", "", "Evry Norge As - Oslo (NO)"},
	{0,"85.93.217.105", "", "Visual Online S.A. - Luxembourg (LU)"},
	{0,"91.229.232.57", "185.52.0.55", "RouteLabel V.O.F. -  (NL)"},
	{0,"200.11.52.202", "", "Telefonica del Peru S.A.A. - Lima (PE)"},
	{0,"80.67.169.40", "80.67.169.12", "Association Gitoyen -  (FR)"},
	{0,"4.2.2.1", "4.2.2.2", "LEVEL3 -  (US)"},
	{0,"149.112.112.112", "149.112.112.11", "QUAD9-AS-1 -  (US)"},
	{0,"8.20.247.20", "", "NUCDN -  (US)"},
	{0,"1.33.184.105", "1.33.184.173", "NTT PC Communications Inc. - Setagaya-ku (JP)"},
	{0,"8.8.8.8", "", "GOOGLE -  (US)"},
	{0,"159.134.248.17", "", "Eir Broadband - Naas (IE)"},
	{0,"94.236.218.254", "", "Petros Ltd. - Sofia (BG)"},
	{0,"177.104.127.114", "", "T-NET WIRELESS E INFORMA&#769 TICA - Fortaleza (BR)"},
	{0,"41.231.30.138", "193.95.93.243", "ORANGE -  (TN)"},
	{0,"195.10.195.195", "", "meerfarbig GmbH & Co. KG -  (DE)"},
	{0,"209.209.217.168", "", "IDS-AS-BAYOU -  (US)"},
	{0,"184.71.101.186", "", "SHAW - Kelowna (CA)"},
	{0,"109.202.11.6", "", "JSC Avantel - Barnaul (RU)"},
	{0,"109.228.25.186", "109.228.46.244", "1&1 Ionos Se -  (GB)"},
	{0,"200.68.46.21", "", "CTC. CORP S.A. (TELEFONICA EMPRESAS) - Chimbarongo (CL)"},
	{0,"207.35.8.169", "184.149.50.25", "BACOM - Etobicoke (CA)"},
	{0,"202.83.121.10", "103.30.247.73", "PT. Cybertechtonic Pratama -  (ID)"},
	{0,"204.50.158.125", "", "AS3602-ROGERS-COM -  (CA)"},
	{0,"91.239.207.90", "", "Proservice LLC - Tbilisi (GE)"},
	{0,"49.0.184.30", "", "YOKOZUNANET LLC - Ulaangom (MN)"},
	{0,"103.85.105.210", "103.85.104.36", "Telecom International Myanmar Co. Ltd - Yangon (MM)"},
	{0,"63.246.63.142", "", "OMEGA-TX - Greenville (US)"},
	{0,"195.189.131.1", "195.189.130.1", "Christian Ebsen ApS -  (DK)"},
	{0,"87.254.34.102", "", "IMC AS -  (NO)"},
	{0,"86.102.30.109", "213.24.238.26", "Rostelecom - Vladivostok (RU)"},
	{0,"188.225.179.158", "", "Coolnet New Communication Provider - Nahal Qatif (PS)"},
	{0,"213.115.226.2", "", "Telenor Norge AS - Balsta (SE)"},
	{0,"161.200.96.9", "202.28.197.202", "Chulalongkorn University - Bang Khae (TH)"},
	{0,"170.210.83.110", "", "Red de Interconexion Universitaria - Neuquén (AR)"},
	{0,"103.232.65.73", "", "PT. KINEZ CREATIVE SOLUTIONS - Tangerang (ID)"},
	{0,"216.187.93.250", "", "IDIGITAL - Vancouver (CA)"},
	{0,"81.17.31.34", "", "Private Layer INC -  (PA)"},
	{0,"45.173.200.10", "", "INVERSIONES EN TELECOMUNICACIONES DIGITALES S.A.C - Jauja (PE)"},
	{0,"128.238.2.38", "", "NYU-POLY -  (US)"},
	{0,"190.151.144.21", "", "Lima Video Cable S.A. (Cabletel) - Zárate (AR)"},
	{0,"194.225.152.10", "", "Institute for Research in Fundamental Sciences -  (IR)"},
	{0,"66.28.0.61", "66.28.0.45", "COGENT-174 - Houston (US)"},
	{0,"198.82.247.34", "2001:468:c80:2101:0:100:0:22", "VA-TECH-AS - Blacksburg (US)"},
	{0,"200.42.174.188", "", "Telefonica Empresas - Casablanca (CL)"},
	{0,"ip_address", "", "as_org - city (country_code)"},
	{0,"137.116.208.102", "", "MICROSOFT-CORP-MSN-AS-BLOCK - Amsterdam (NL)"},
	{0,"202.21.99.42", "", "Mobinet LLC. AS Mobinet Internet Service Provider -  (MN)"},
	{0,"107.155.83.188", "", "HVC-AS - Dallas (US)"},
	{0,"186.248.139.42", "", "AMERICAN TOWER DO BRASIL-COMUNICACAO MULTIMIDIA LT - Belo Horizonte (BR)"},
	{0,"81.27.162.100", "", "R-KOM Telekommunikationsgesellschaft mbH & Co. KG - Regensburg (DE)"},
	{0,"176.94.20.4", "91.208.193.1", "Vodafone GmbH - Hamburg (DE)"},
	{0,"189.125.18.5", "216.136.95.2", "LVLT-3549 - Mandirituba (BR)"},
	{0,"64.233.217.2", "69.1.1.251", "WOW-INTERNET - Saint Clair Shores (US)"},
	{0,"200.62.147.66", "", "America Movil Peru S.A.C. - Callao (PE)"},
	{0,"62.48.241.226", "195.8.8.2", "Servicos De Comunicacoes E Multimedia S.A. - Carcavelos (PT)"},
	{0,"202.62.224.2", "", "M/s Ortel Communications Ltd -  (IN)"},
	{0,"203.201.60.12", "", "Bell Teleservices India Pvt Ltd. India. - Bengaluru (IN)"},
	{0,"210.0.128.241", "210.0.255.144", "HGC Global Communications Limited - Ngau Kok Wan (HK)"},
	{0,"210.181.4.25", "", "DREAMLINE CO. -  (KR)"},
	{0,"205.214.45.10", "", "MEGAPATH2 -  (US)"},
	{0,"208.91.112.220", "208.91.112.53", "FORTINET - Burnaby (CA)"},
	{0,"192.146.229.22", "", "Empresa Brasileira de Ens.Peq.Extensao S/A-EMBRAE -  (BR)"},
	{0,"189.42.239.34", "189.55.193.173", "CLARO S.A. -  (BR)"},
	{0,"209.143.0.10", "", "INDEPENDENTSFIBERNETWORK - Oakwood (US)"},
	{0,"190.64.140.243", "200.40.255.101", "Administracion Nacional de Telecomunicaciones - Montevideo (UY)"},
	{0,"190.151.20.146", "164.77.245.34", "ENTEL CHILE S.A. - Nunoa (CL)"},
	{0,"199.166.6.2", "209.239.11.98", "EXECULINK -  (CA)"},
	{0,"62.37.225.56", "212.31.32.131", "Orange Espagne SA - Sueca (ES)"},
	{0,"103.244.159.82", "202.130.102.211", "HKBN Enterprise Solutions HK Limited - Tai Kok Tsui (HK)"},
	{0,"212.124.226.242", "", "CENTURYLINK-LEGACY-SAVVIS -  (AT)"},
	{0,"147.78.3.252", "", "PE Ivanov Vitaliy Sergeevich - Kyiv (UA)"},
	{0,"217.14.128.50", "", "Domainmaster LTD -  (GB)"},
	{0,"211.115.194.2", "", "Sejong Telecom -  (KR)"},
	{0,"213.55.96.166", "213.55.96.148", "Ethiopian Telecommunication Corporation -  (ET)"},
	{0,"212.19.159.50", "", "JSC Kazakhtelecom -  (KZ)"},
	{0,"65.39.139.53", "72.51.45.191", "COGECO-PEER1 - Vancouver (CA)"},
	{0,"66.232.139.10", "", "Hostway IDC -  (US)"},
	{0,"83.137.41.8", "83.137.41.9", "nemox.net Informationstechnologie OG - Terfens (AT)"},
	{0,"205.171.2.25", "205.171.202.25", "CENTURYLINK-US-LEGACY-QWEST -  (US)"},
	{0,"195.7.64.3", "", "GTT Communications Inc. -  (US)"},
	{0,"91.183.238.145", "", "Proximus NV - Brussels (BE)"},
	{0,"66.163.0.161", "66.163.0.173", "RADIANT-TORONTO - Oshawa (CA)"},
	{0,"207.248.57.11", "", "Television Internacional S.A. de C.V. - Monterrey (MX)"},
	{0,"66.242.160.6", "", "AYERA-AS -  (US)"},
	{0,"194.224.229.56", "", "Ingenia S.A. -  (ES)"},
	{0,"200.76.5.147", "200.94.26.115", "Alestra S. de R.L. de C.V. - San Luis Potosí City (MX)"},
	{0,"209.216.160.131", "209.216.160.2", "GORGE-NETWORKS - Grass Valley (US)"},
	{0,"162.245.221.19", "", "PUREVOLTAGE-INC - Staten Island (US)"},
	{0,"95.158.129.2", "", "novatel Eood - Sofia (BG)"},
	{0,"193.58.204.59", "", "ML Consultancy -  (NL)"},
	{0,"211.63.64.11", "", "purplestones -  (KR)"},
	{0,"202.182.0.1", "", "Milcom Co. Ltd. Internet Service Provider Bangkok -  (TH)"},
	{0,"210.228.48.238", "61.120.59.210", "KDDI CORPORATION - Chitose (JP)"},
	{0,"122.56.105.82", "", "Global-Gateway Internet - Auckland (NZ)"},
	{0,"62.134.11.4", "81.138.71.238", "British Telecommunications PLC -  (GB)"},
	{0,"151.80.222.79", "5.196.123.133", "OVH SAS - Roubaix (FR)"},
	{0,"87.117.196.200", "", "Iomart Cloud Services Limited - Chelmsford (GB)"},
	{0,"110.172.55.126", "", "WISH NET PRIVATE LIMITED -  (IN)"},
	{0,"185.161.112.33", "185.161.112.34", "Parvaz System Information Technology Company (Ltd) -  (IR)"},
	{0,"90.183.151.106", "90.183.151.107", "O2 Czech Republic a.s. - Pardubice (CZ)"},
	{0,"198.180.150.12", "", "RGnet OU -  (EE)"},
	{0,"46.227.67.134", "", "Obehosting AB - Stockholm (SE)"},
	{0,"69.162.67.202", "", "LIMESTONENETWORKS -  (US)"},
	{0,"212.19.106.134", "", "Leonet srl - Livorno (IT)"},
	{0,"103.121.228.1", "", "MyanmarAPN - Yangon (MM)"},
	{0,"185.233.106.232", "188.68.53.22", "netcup GmbH -  (DE)"},
	{0,"89.29.128.250", "", "Tv Almansa S.l. - Montealegre del Castillo (ES)"},
	{0,"178.248.160.140", "", "Ulysse Group S.A. -  (BE)"},
	{0,"78.130.39.189", "", "Nos Comunicacoes S.A. - Maia (PT)"},
	{0,"37.48.120.196", "", "LeaseWeb Netherlands B.V. -  (NL)"},
	{0,"210.190.105.66", "153.142.244.29", "NTT Communications Corporation - Kita (JP)"},
	{0,"62.97.223.62", "", "BKK Digitek AS - Bergen (NO)"},
	{0,"185.20.163.2", "", "Fanava Group -  (IR)"},
	{0,"194.39.205.240", "", "Webhosting24 GmbH - Munich (DE)"},
	{0,"87.215.134.201", "", "Tele2 Nederland B.V. -  (NL)"},
	{0,"195.112.96.34", "", "MAXnet Systems Ltd. - Obninsk (RU)"},
	{0,"193.190.213.42", "", "BELNET - Vossem (BE)"},
	{0,"5.133.40.77", "", "Grain Communications Limited - Carlisle (GB)"},
	{0,"62.233.128.17", "213.241.88.98", "Netia SA -  (PL)"},
	{0,"103.226.174.4", "103.226.174.7", "Universitas Muhammadiyah Surakarta -  (ID)"},
	{0,"69.7.192.2", "", "FIRSTCOMM-AS2 -  (US)"},
	{0,"170.56.58.53", "", "EntServ Deutschland GmbH -  ()"},
	{0,"212.244.48.137", "79.190.224.27", "Orange Polska Spolka Akcyjna - Kwidzyn (PL)"},
	{0,"43.224.122.28", "", "MikiPro Ltd - Auckland (NZ)"},
	{0,"202.182.53.17", "101.255.56.249", "PT Remala Abadi - Jakarta (ID)"},
	{0,"200.115.176.23", "", "Banco del Pais -  (HN)"},
	{0,"203.81.75.37", "", "Myanma Posts and Telecommunications -  (MM)"},
	{0,"208.67.222.220", "", "OPENDNS -  (US)"},
	{0,"209.51.161.14", "65.49.37.195", "HURRICANE -  (US)"},
	{0,"200.221.11.101", "", "Universo Online S.A. -  (BR)"},
	{0,"195.252.95.208", "", "BeotelNet-ISP d.o.o - Aleksinac (RS)"},
	{0,"142.165.78.223", "", "SASKTEL - Lloydminster (CA)"},
	{0,"211.188.11.201", "", "KT POWERTEL -  (KR)"},
	{0,"190.54.120.23", "", "Telmex Chile Internet S.A. - Santiago (CL)"},
	{0,"77.88.8.1", "77.88.8.88", "YANDEX LLC -  (RU)"},
	{0,"194.67.109.176", "", "Domain names registrar REG.RU Ltd -  (RU)"},
	{0,"201.217.41.78", "", "CO.PA.CO. - Asunción (PY)"},
	{0,"117.55.243.14", "", "CJONLINE ISP India - Greater Noida (IN)"},
	{0,"63.171.232.38", "", "Colombia -  (US)"},
	{0,"200.142.160.54", "", "Telespazio Brasil S.A. - Rio de Janeiro (BR)"},
	{0,"1.0.0.2", "1.1.1.2", "CLOUDFLARENET -  (AU)"},
	{0,"88.151.140.202", "", "INEA S.A. - Konin (PL)"},
	{0,"37.235.70.59", "", "OOO MediaSeti - Nizhniy Novgorod (RU)"},
	{0,"194.179.1.100", "195.77.235.10", "Telefonica De Espana -  (ES)"},
	{0,"137.82.1.1", "", "UBC - Vancouver (CA)"},
	{0,"42.116.255.180", "", "The Corporation for Financing & Promoting Technology - Ho Chi Minh City (VN)"},
	{0,"200.6.203.241", "190.56.163.189", "Telgua - Guatemala City (GT)"},
	{0,"129.250.35.250", "", "NTT-COMMUNICATIONS-2914 -  (US)"},
	{0,"223.6.6.6", "", "Hangzhou Alibaba Advertising Co.Ltd. -  (CN)"},
	{0,"186.216.63.97", "", "METROFLEX TELECOMUNICACOES LTDA - Niterói (BR)"},
	{0,"91.203.177.216", "", "MAN net Ltd. - Smolensk (RU)"},
	{0,"195.250.58.10", "", "ACTUAL I.T. d.d. -  (SI)"},
	{0,"186.211.1.191", "", "PortalSAT Telecom - Brumado (BR)"},
	{0,"84.52.103.114", "", "JSC ER-Telecom Holding - St Petersburg (RU)"},
	{0,"46.224.1.43", "", "Dadeh Gostar Asr Novin P.J.S. Co. -  (IR)"},
	{0,"41.58.181.74", "", "SWIFTNG-ASN - Lagos (NG)"},
	{0,"74.50.211.86", "69.160.4.206", "OOREDOO MYANMAR -  (MM)"},
	{0,"213.52.192.198", "", "Telecitygroup International Limited -  (GB)"},
	{0,"177.104.118.42", "", "S&T PARTICIPACOES LTDA - ME - Fortaleza (BR)"},
	{0,"66.199.241.115", "", "EZZI-101-BGP -  (US)"},
	{0,"216.237.114.148", "216.237.114.149", "INFORTECH-001 -  (US)"},
	{0,"109.234.248.8", "", "PlusServer GmbH -  (DE)"},
	{0,"209.105.243.218", "", "ZC38-AS1 -  (US)"},
	{0,"203.143.0.25", "", "Lanka Communication Services - Colombo (LK)"},
	{0,"178.237.150.2", "", "Maxen Technologies S.l. - Tordera (ES)"},
	{0,"185.228.169.9", "185.228.168.9", "Daniel Cid -  (US)"},
	{0,"91.137.135.75", "", "OPC Networks Kft. - Nagykoros (HU)"},
}

return _servers
