local _servers =
{
	{1, " 103.31.228.150", "               ", "TELEKOMUNIKASI INDONESIA INTERNATIONAL PTE.LTD -  (SG)"},
	{1, "185.121.177.177", "               ", "Silent Ghost e.U. -  (AQ)"},
	{1, "  211.237.65.21", "               ", "SKTelink -  (KR)"},
	{1, "    83.137.41.8", "    83.137.41.9", "nemox.net Informationstechnologie OG - Terfens (AT)"},
	{1, "  81.27.162.100", "               ", "R-KOM Telekommunikationsgesellschaft mbH & Co. KG - Regensburg (DE)"},
	{1, "176.103.130.130", "176.103.130.137", "Serveroid LLC -  (RU)"},
	{1, "186.179.241.146", "               ", "Telecommunicationcompany Suriname - TeleSur - Onverwacht (SR)"},
	{1, "   201.20.36.29", " 200.143.177.83", "EQUINIX BRASIL - São Paulo (BR)"},
	{1, " 121.100.28.163", "               ", "PT. Sakti Putra Mandiri - Palembang (ID)"},
	{1, "    92.60.50.40", "               ", "BONET Systems s.r.o. - Bratislava (SK)"},
	{1, " 195.140.195.21", " 195.140.195.22", "TREX Regional Exchanges Oy -  (FI)"},
	{1, "    46.224.1.43", "               ", "Dadeh Gostar Asr Novin P.J.S. Co. -  (IR)"},
	{1, "122.200.254.203", "               ", "KDDI Web Communications Inc. -  (JP)"},
	{1, "   85.132.32.41", "               ", "CASPEL LLC - Baku (AZ)"},
	{1, "   199.2.252.10", " 217.147.96.210", "SPRINTLINK -  (US)"},
	{1, "   200.169.88.1", "               ", "Visualcorp Holding Ltda - São Paulo (BR)"},
	{1, "    195.60.70.6", "               ", "VAK Ltd. - Poltava (UA)"},
	{1, "   37.99.224.30", "               ", "Irpinia Net-Com SRL - Montoro Inferiore (IT)"},
	{1, "   91.214.72.34", "               ", "Positivo Srl - Salerno (IT)"},
	{1, "    81.17.31.34", "               ", "Private Layer INC -  (PA)"},
	{1, "   178.17.127.1", "               ", "BT NET d.o.o. za trgovinu i usluge - Varaždin (HR)"},
	{1, "134.153.233.140", "               ", "MEMORIALU - St. John's (CA)"},
	{1, "  177.67.81.134", "               ", "W I X NET DO BRASIL LTDA - ME -  (BR)"},
	{1, " 208.79.218.162", "               ", "ESTRUXTURE -  (CA)"},
	{1, "208.254.148.100", "               ", "POPP-COM -  (US)"},
	{1, "  199.85.127.20", "   156.154.70.3", "NEUSTAR-AS6 -  (US)"},
	{1, "  66.216.18.222", "               ", "BBO-1 - Cleveland (US)"},
	{1, "    109.69.8.51", "               ", "Fundacio Privada per a la Xarxa Lliure guifi.net - Amposta (ES)"},
	{1, "   124.158.93.2", "               ", "STXCitinet Mongolia -  (MN)"},
	{1, "   62.149.128.4", "   62.149.128.2", "Aruba S.p.A. - Arezzo (IT)"},
	{1, "   91.204.4.133", "               ", "Wissenschaftsladen Dortmund e.V. -  (DE)"},
	{1, "  213.55.96.166", "  213.55.96.148", "Ethiopian Telecommunication Corporation -  (ET)"},
	{1, "   5.254.96.195", "               ", "Voxility LLP -  (GB)"},
	{1, " 103.246.17.195", "               ", "POPIDC powered by CSLoxinfo -  (TH)"},
	{1, " 66.119.188.199", "               ", "TRGO -  (CA)"},
	{1, "122.129.122.100", " 122.129.122.99", "Malaysian Research & Education Network - Kuala Lumpur (MY)"},
	{1, "   181.210.92.7", "               ", "Hondutel - Rio Comayagua (HN)"},
	{1, " 149.112.121.20", " 149.112.121.30", "CIRADNS3 -  (CA)"},
	{1, " 185.161.112.33", " 185.161.112.38", "Parvaz System Information Technology Company (Ltd) -  (IR)"},
	{1, " 185.117.118.20", "               ", "Oy Crea Nova Hosting Solution Ltd - Helsinki (FI)"},
	{1, "   196.3.10.222", "               ", "NUSTREAM-COMMUNICATIONS -  (PR)"},
	{1, "    195.208.4.1", "    62.76.76.62", "Joint-stock company Internet Exchange MSK-IX -  (RU)"},
	{1, "      8.15.12.5", "               ", "ACN-DIGITAL-PHONE -  (US)"},
	{1, "  23.226.80.100", "               ", "PLEXICOMM - Binghamton (US)"},
	{1, "  89.107.129.15", "               ", "ASTELNET s.r.o. -  (DE)"},
	{1, "   95.158.129.2", "               ", "novatel Eood - Sofia (BG)"},
	{1, "   46.36.105.99", "               ", "Pirooz Leen LLC -  (IR)"},
	{1, "162.241.226.169", "               ", "UNIFIEDLAYER-AS-1 -  (US)"},
	{1, "    80.80.81.81", "    80.80.80.80", "Freedom Registry BV -  (NL)"},
	{1, "   24.113.32.29", "   24.113.32.30", "AS-WAVE-1 - Port Orchard (US)"},
	{1, " 187.49.127.110", "               ", "G3 TELECOM - Salvador (BR)"},
	{1, " 63.105.204.164", "               ", "KINX -  (US)"},
	{1, "     96.7.136.4", "               ", "Akamai International B.V. -  (US)"},
	{1, " 217.170.128.27", "217.170.133.134", "Nexthop AS - Oslo (NO)"},
	{1, "    92.43.224.1", "               ", "OmniAccess S.L. -  (ES)"},
	{1, "  199.85.126.10", "  199.85.127.30", "ULTRADNS -  (US)"},
	{1, "      84.8.2.11", "               ", "alwaysON Limited -  (GB)"},
	{1, "   202.44.32.29", "   202.44.45.11", "King Mongkut's Institute of Technology North Bangkok - Nonthaburi (TH)"},
	{1, "  109.70.207.80", " 109.70.207.146", "LA Wireless Srl - Como (IT)"},
	{1, "   185.81.41.81", "               ", "Rooyekhat Media Company Ltd -  (IR)"},
	{1, " 193.186.170.50", "  185.242.177.8", "LINZ STROM GAS WAERME GmbH fuer Energiedienstleistungen und Telekommunikation - Linz (AT)"},
	{1, "   212.28.34.65", "               ", "Transkom GmbH -  (DE)"},
	{1, " 192.232.128.20", "               ", "BOX HILL INSTITUTE - Mont Albert (AU)"},
	{1, "  89.234.141.66", "               ", "Association Alsace Reseau Neutre - Strasbourg (FR)"},
	{1, "  82.103.129.72", "               ", "ASERGO Scandinavia ApS - Copenhagen (DK)"},
	{1, " 104.152.211.99", "               ", "RICAWEBSERVICES -  (CA)"},
	{1, "   218.30.118.6", "               ", "IDC China Telecommunications Corporation -  (CN)"},
	{1, "    101.226.4.6", "               ", "China Telecom (Group) -  (CN)"},
	{1, "  188.191.160.1", "               ", "Intelsc Ltd. - Kraskovo (RU)"},
	{1, " 223.31.121.171", "               ", "Power Grid Corporation of India Limited - Bhubaneswar (IN)"},
	{1, " 190.151.144.21", "               ", "Lima Video Cable S.A. (Cabletel) - Zárate (AR)"},
	{1, "  91.147.96.169", "               ", "Mobile Business Solution MBS LLP -  (KZ)"},
	{1, "  188.130.81.50", "               ", "CTS Computers and Telecommunications Systems SAS - Fontenay-sous-Bois (FR)"},
	{1, "   203.253.64.1", "               ", "Hankuk University of Foreign Studies Computer Center - Yongin-si (KR)"},
	{1, "   170.56.58.53", "               ", "EntServ Deutschland GmbH -  ()"},
	{1, "  5.200.200.200", "   85.185.157.2", "Iran Telecommunication Company PJS -  (IR)"},
	{1, "   84.91.197.19", "               ", "Nowo Communications S.A. - Palmela (PT)"},
	{1, " 129.250.35.250", " 129.250.35.251", "NTT-COMMUNICATIONS-2914 -  (US)"},
	{1, "    64.119.60.5", "    64.119.60.9", "SPEEDCONNECT -  (US)"},
	{1, " 69.169.190.211", "               ", "OFF-CAMPUS-TELECOMMUNICATIONS - Payson (US)"},
	{1, "   103.9.183.20", "   103.9.183.40", "Universitas Kristen Satya Wacana -  (ID)"},
	{1, "    216.106.1.3", "  216.106.1.254", "SOCKET - Columbia (US)"},
	{1, " 188.227.240.58", "               ", "Blaze Networks Ltd - London (GB)"},
	{1, " 202.112.35.203", "               ", "China Education and Research Network Center -  (CN)"},
	{1, "   81.8.176.251", "               ", "AC-Net Externservice AB - Vilhelmina (SE)"},
	{1, "   46.254.14.12", "               ", "City Network International AB - Stockholm (SE)"},
	{1, " 186.167.16.187", "               ", "Corporacion Digitel C.A. -  (VE)"},
	{1, "  209.137.146.2", "               ", "KDDIA-NET - Compton (US)"},
	{1, "    177.87.96.4", "               ", "Governo do Estado do Rio Grande do Norte - Natal (BR)"},
	{1, " 200.10.231.190", "               ", "Centro Nacional de Computacion -  (PY)"},
	{1, " 192.141.232.10", "               ", "Brasil Central Telecomunicacao - Padre Bernardo (BR)"},
	{1, "179.127.175.242", "               ", "Unifique Telecomunicacoes SA - Corupa (BR)"},
	{1, "193.111.200.191", "               ", "Gradwell Communications Limited -  (GB)"},
	{1, "   46.16.216.25", "               ", "Wireless Logic mdex GmbH -  (DE)"},
	{1, "  212.60.64.211", "               ", "Gamtele - Banjul (GM)"},
	{1, "   80.78.134.11", "               ", "Cheyenne Technologies LLC -  (DE)"},
	{1, " 83.236.183.211", "               ", "Plusnet GmbH - Springe (DE)"},
	{1, "   66.6.128.111", "               ", "SKY-WEB -  (US)"},
	{1, "138.219.105.100", "               ", "Acem Telecom Ltda -  (BR)"},
	{1, " 116.68.170.150", "               ", "PT Sumber Data Indonesia -  (ID)"},
	{1, "   198.60.22.22", "               ", "XMISSION -  (US)"},
	{1, "  109.71.42.228", "               ", "Almouroltec Servicos De Informatica E Internet Lda - Lisbon (PT)"},
	{1, "    74.81.71.27", "               ", "NTHL -  (US)"},
	{1, " 91.103.112.150", "               ", "NetCom BW GmbH - Stuttgart (DE)"},
	{1, " 152.89.170.250", "               ", "C1V Edizioni di Cinzia Tocci - Rome (IT)"},
	{1, "  185.82.22.133", "               ", "Droptop GmbH -  (DE)"},
	{1, "  41.57.188.119", "               ", "Neotel Pty Ltd -  (ZA)"},
	{1, "   216.12.255.1", "               ", "WAYPORT - Austin (US)"},
	{1, "  189.89.61.244", "               ", "LINK POINT SERVICOS LTDA-ME - Junqueiro (BR)"},
	{1, " 208.89.131.199", "               ", "AS-IRISTEL -  (CA)"},
	{1, " 193.34.173.206", "               ", "New Information Systems PP - Bushtyno (UA)"},
	{1, " 173.234.56.115", "               ", "LEASEWEB - Chelsea (US)"},
	{1, "  208.78.24.238", "               ", "AMC - The Bronx (US)"},
	{1, " 162.223.88.133", "               ", "COLOUP - Buffalo (US)"},
	{1, "150.254.125.203", "               ", "Institute of Bioorganic Chemistry Polish Academy of Science Poznan Supercomputing and Networ -  (PL)"},
	{1, "149.112.112.112", " 149.112.112.10", "QUAD9-AS-1 -  (US)"},
	{1, "101.102.103.104", "101.101.101.101", "Taiwan Network Information Center -  (TW)"},
	{1, " 195.58.249.154", "               ", "Private joint-stock company (PrJSC) DORIS - Novopskov (UA)"},
	{1, " 209.211.254.19", " 209.211.254.18", "LRCSNET - Rock Springs (US)"},
	{1, "   84.200.70.40", "               ", "Accelerated IT Services & Consulting GmbH -  (DE)"},
	{1, " 62.217.240.110", "               ", "Orange Romania S.A. - Bucharest (RO)"},
	{1, "   78.7.251.131", "               ", "BT Italia S.p.A. -  (IT)"},
	{1, "  205.214.45.10", "               ", "MEGAPATH2 -  (US)"},
	{1, "  212.92.193.18", "               ", "A1 Hrvatska d.o.o. - Zagreb (HR)"},
	{1, "   185.53.143.3", "               ", "Dade Pardazi Mobinhost Co LTD -  (IR)"},
	{1, "    69.67.97.18", "               ", "TELENET-INTL - Littleton (US)"},
	{1, " 41.221.192.167", "               ", "CV-Multimedia -  (CV)"},
	{1, "  194.164.181.2", "  194.164.181.6", "Kcom Group Limited -  (GB)"},
	{1, " 203.242.169.11", "               ", "Korea Trade Network -  (KR)"},
	{1, "    212.51.16.1", "               ", "ADDIX Internet Services GmbH - Kiel (DE)"},
	{1, "  81.30.212.189", "               ", "JSC Ufanet - Ufa (RU)"},
	{1, "     195.27.1.1", "               ", "CW Vodafone Group PLC -  (GB)"},
	{1, " 103.198.192.43", "               ", "Gigabit Hosting Sdn Bhd -  (HK)"},
	{1, "  202.44.204.36", "               ", "Thailand Public backbone Network -  (TH)"},
	{1, "193.111.144.161", "               ", "Uniwersytet Technologiczno-Humanistyczny Im. Kazimierza Pulaskiego W Radomiu - Radom (PL)"},
	{1, "  185.107.80.84", "               ", "NForce Entertainment B.V. - Pijnacker (NL)"},
	{1, "  212.97.129.34", "               ", "Keepit A/S -  (DK)"},
	{1, "   45.90.28.193", "   45.90.30.193", "nextdns Inc. -  (US)"},
	{1, " 146.196.40.106", "               ", "PT. Cahaya Buana Raksa - Bolang (ID)"},
	{1, "  103.61.69.185", "               ", "Fastway Global Limited -  (NZ)"},
	{1, " 195.10.195.195", "               ", "meerfarbig GmbH & Co. KG -  (DE)"},
	{1, " 91.235.244.201", "               ", "InterLogica Ltd. - Moscow (RU)"},
	{1, " 193.238.223.91", "               ", "Telenet SIA - Riga (LV)"},
	{1, "   62.140.239.1", "               ", "LLC trc Fiord - Kyiv (UA)"},
	{1, "  196.3.132.153", "  190.58.23.133", "Telecommunication Services of Trinidad and Tobago -  (TT)"},
	{1, "  158.51.134.53", "               ", "NONEXISTE-AS -  (US)"},
	{1, "   92.55.56.232", "               ", "OOO NI - Izhevsk (RU)"},
	{1, "  157.92.190.15", "               ", "Universidad Nacional de Buenos Aires - Buenos Aires (AR)"},
	{1, " 200.221.11.100", " 200.221.11.101", "Universo Online S.A. -  (BR)"},
	{1, " 195.226.206.15", "               ", "Consiliul Judetean Bistrita-Nasaud -  (RO)"},
	{1, " 201.174.34.194", " 201.174.34.195", "TRANSTELCO-INC -  (MX)"},
	{1, "  152.74.109.11", "               ", "Red Universitaria Nacional - San Pedro de la Paz (CL)"},
	{1, " 125.212.202.19", "               ", "CHT Compamy Ltd -  (VN)"},
	{1, "  91.205.144.27", "               ", "LanCraft Ltd. - Krasnogorsk (RU)"},
	{1, "  216.21.128.22", "  216.21.129.22", "RADIANT-VANCOUVER - Richmond (CA)"},
	{1, "  185.228.169.9", "  185.228.168.9", "Daniel Cid -  (US)"},
	{1, " 84.237.112.130", "               ", "Federal Research Center for Information and Computational Technologies - Novosibirsk (RU)"},
	{1, "   66.163.0.161", "   66.163.0.173", "RADIANT-TORONTO - Oshawa (CA)"},
	{1, " 199.255.95.193", "               ", "FTNET - Fossil (US)"},
	{1, "  212.118.241.1", " 212.118.241.33", "InterNAP Network Services U.K. Limited -  (GB)"},
	{1, "  185.51.204.10", "  185.51.204.11", "Al wafai International For Communication and Information Technology LLC - Jeddah (SA)"},
	{1, "  91.143.212.70", "               ", "Serbia BroadBand-Srpske Kablovske mreze d.o.o. - Belgrade (RS)"},
	{1, " 204.106.240.53", "               ", "DMCI-BROADBAND - Reading (US)"},
	{1, "  206.51.143.55", "               ", "NKTC - Sidney (US)"},
	{1, "162.221.207.228", "               ", "ESECUREDATA -  (CA)"},
	{1, " 74.203.248.220", "               ", "USPI -  (US)"},
	{1, "     80.64.32.2", "               ", "GRN Serveis Telematics SL - Girona (ES)"},
	{1, "178.175.139.211", "               ", "I.C.S. Trabia-Network S.R.L. - Chisinau (MD)"},
	{1, "  45.143.197.10", "               ", "Serverius Holding B.V. -  (IN)"},
	{1, "195.113.144.194", "               ", "CESNET z.s.p.o. - Pardubice (CZ)"},
	{1, "   153.39.49.42", "   153.39.50.42", "UUNET-INT -  (US)"},
	{1, "  189.90.241.10", "               ", "Companhia Itabirana Telecomunicacoes Ltda - Contagem (BR)"},
	{1, "  207.210.233.4", "               ", "INTELLECTICA - Dallas (US)"},
	{1, "    62.40.32.33", "               ", "Three Ireland (Hutchison) limited - Raheen (IE)"},
	{1, "   94.140.15.15", "  94.140.14.141", "AdGuard Software Limited -  (CY)"},
	{1, "    80.79.179.2", "               ", "Cjsc Race Telecom -  (RU)"},
	{1, " 196.15.170.131", "               ", "SAIX-NET - Secunda (ZA)"},
	{1, "   194.27.192.6", "   194.27.192.5", "Galatasaray Universitesi - Istanbul (TR)"},
	{1, " 89.150.195.195", "               ", "Media Network i Halmstad AB - Holm (SE)"},
	{1, "  94.247.43.254", "               ", "Lennart Seitz -  (DE)"},
	{1, "  194.172.160.4", "    91.217.86.4", "Baumann Technologie GmbH -  (DE)"},
	{1, "   65.203.109.2", "               ", "CTSINET -  (US)"},
	{1, "  177.184.176.5", "               ", "Netcar Internet Telec Info e Tecnologia LTDA - Carbonita (BR)"},
	{1, "  208.79.56.204", " 208.72.120.204", "295CA-TOR-ASN - Elora (CA)"},
	{1, "  193.183.18.21", "               ", "Atea A/S -  (SE)"},
	{1, "185.222.222.222", "185.184.222.222", "XTOM -  ()"},
	{1, "    200.169.8.1", "               ", "Century Telecom Ltda - Belo Horizonte (BR)"},
	{1, "     82.96.65.2", "     82.96.64.2", "Probe Networks -  (DE)"},
	{1, "  91.229.233.40", "               ", "OOO Red Star - St Petersburg (RU)"},
	{1, "204.194.232.200", "204.194.234.200", "302-DIRECT-MEDIA-ASN -  (US)"},
	{1, " 183.177.101.51", "               ", "ICNC LLC -  (MN)"},
	{1, "  138.0.207.117", "               ", "L. Garcia Comunicacoes ME - Birigui (BR)"},
	{1, "  78.157.40.158", "  78.157.40.157", "Dade Samane Fanava Company (PJS) -  (IR)"},
	{1, "   212.94.32.32", "   212.94.34.34", "acdalis ag - Suhr (CH)"},
	{1, "    203.147.7.7", "               ", "Jasmine Internet Co Ltd. -  (TH)"},
	{1, " 192.232.128.21", "               ", "Box Hill Institute of TAFE - Kilsyth (AU)"},
	{1, "   64.233.207.2", "  64.233.207.16", "WOW-INTERNET - Cleveland (US)"},
	{1, " 87.117.196.200", "               ", "Iomart Cloud Services Limited - Chelmsford (GB)"},
	{1, " 203.119.36.106", "117.122.125.106", "Vietnam Internet Network Information Center -  (VN)"},
	{1, "158.132.187.187", "               ", "Information Technology Services -  (HK)"},
	{1, "    134.195.4.2", "               ", "NEXTGI -  (US)"},
	{1, " 206.253.33.130", "               ", "PIONEERINTERNET - Moscow (US)"},
	{1, "   165.246.10.2", "               ", "INHA UNIVERSITY -  (KR)"},
	{1, " 181.114.59.245", "               ", "Netsys -  (HN)"},
	{1, " 212.89.130.180", "               ", "InfoServe GmbH - Quierschied (DE)"},
	{1, "   103.23.20.23", "   117.53.46.10", "PT Infinys System Indonesia -  (ID)"},
	{1, "  109.205.112.9", "               ", "ScopeSky Communication and Internet Ltd. - Baghdad (IQ)"},
	{1, "103.134.220.158", "               ", "PT Global Media Pratama Solusindo -  (ID)"},
	{1, "  203.192.198.5", "               ", "AS Number of Indusind Media and communication Ltd. - Hyderabad (IN)"},
	{1, "  118.238.28.66", "               ", "So-net Entertainment Corporation - Setagaya-ku (JP)"},
	{1, " 151.252.139.24", "               ", "Net at Once Sweden AB - Lagan (SE)"},
	{1, " 177.200.78.209", "               ", "SKYNET TELECOMUNICACOES EIRELI - Pradopolis (BR)"},
	{1, "  196.200.176.2", " 196.200.184.31", "Moroccan Academic Network - Marrakesh (MA)"},
	{1, "     81.163.3.1", "               ", "Rasana Pishtaz Iranian Service Cooperative Co. -  (IR)"},
	{1, "   194.177.56.1", "               ", "Waycom International SASU - Paris (FR)"},
	{1, "  200.56.224.11", "               ", "Marcatel Com S.A. de C.V. -  (MX)"},
	{1, " 42.116.255.180", "  210.245.89.21", "The Corporation for Financing & Promoting Technology - Ho Chi Minh City (VN)"},
	{1, "210.205.122.161", "               ", "DREAMMARK1 -  (KR)"},
	{1, "  192.133.129.2", "               ", "RITTERNET - Searcy (US)"},
	{1, "  103.23.150.89", "  103.23.150.88", "4th Floor New Administrative Building -  (IN)"},
	{1, "   190.11.225.2", "               ", "COMPANIA DE TELEVISION VIA SATELITE S.A. (TEVISAT S.A.) - La Ceiba (HN)"},
	{1, "   103.5.148.99", "               ", "Badan Pengawas Obat dan Makanan -  (ID)"},
	{1, " 103.224.162.40", "               ", "Ezi-Web -  (AU)"},
	{1, "     81.3.27.54", "               ", "Hostway Deutschland GmbH - Hagenburg (DE)"},
	{1, "   80.254.77.39", "               ", "Monzoon Networks AG - Biel/Bienne (CH)"},
	{1, "  198.82.247.34", "               ", "VA-TECH-AS - Blacksburg (US)"},
	{1, "   162.127.13.1", "               ", "NETWORK NEBRASKA - Holdrege (US)"},
	{1, "  45.71.185.100", "               ", "NEDETEL S.A. - Machala (EC)"},
	{1, "  185.136.96.99", "               ", "Cloud DNS Ltd -  (US)"},
	{1, "    46.35.180.2", "               ", "Skynet Ltd - Oreshak (BG)"},
	{1, "      223.6.6.6", "      223.5.5.5", "Hangzhou Alibaba Advertising Co.Ltd. -  (CN)"},
	{1, "  198.251.100.2", "               ", "NETCOM-PNSDC - Pensacola (US)"},
	{1, "   46.182.19.48", "               ", "NbIServ -  (DE)"},
	{1, "    64.111.16.2", "    208.80.0.62", "D102-COS-1 - Colorado Springs (US)"},
	{1, "  204.9.217.247", "               ", "GETDATACOM -  (US)"},
	{1, "     137.82.1.1", "    142.103.1.1", "UBC - Vancouver (CA)"},
	{1, "    185.34.21.5", "               ", "LTD Erline - Makhachkala (RU)"},
	{1, "   87.247.68.60", "               ", "UAB Cgates - Kaunas (LT)"},
	{1, "  209.150.154.1", "               ", "CMPak Limited - Karachi (PK)"},
	{1, "    212.91.32.6", "               ", "RSAdvSys -  (IT)"},
	{1, "      76.76.2.0", "      76.76.2.3", "CONTROLD -  (CA)"},
	{1, "   196.216.32.2", "               ", "Paratus-Telecom - Windhoek (NA)"},
}

return _servers