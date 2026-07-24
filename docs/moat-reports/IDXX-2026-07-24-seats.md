# IDXX 門A深查 · seats合卷(四席+互盲双席全文·2026-07-24冻结)

- **开案令**:ADJ-0724-03(GM-6·E6·轮08c5·终);prep案卷=docs/moat-reports/IDXX-2026-07-24-prep.md(sha1 90cfaf732dc6e2d960459c52109c9071759e3d44·commit 2c6dfd2)
- **流程执行记录(四席硬隔离)**:①data-verifier数据包席(不spawn子agent条款遵守·价盲)/②财报法证席(八问1/2/5/7·SEC一手)/③竞争镜像席(八问3/4/6/8·一手实证)三席并行→④⑤互盲bull/bear(只吃证据包四件·工具仅Read·互不可见对方)→TL(CGM)综合判定(另卷deepdive)
- **v1.19/v1.20钢印执行申报**:全席派发档=Claude Fable 5(主循环claude-fable-5·子席继承·各席自申报在卷);**同构申报**:五席+TL同模型家族——流程独立(硬隔离/互盲)非模型独立
- **席令瑕疵申报**:CGM派发法证席令时举例"西德州新厂"系凭印象之illustration(prep案卷原文无此项)——法证席按「勿凭印象」纪律证伪(10-K全文texas零命中),如实入卷,验证纪律有效
- **收录顺序**:一、财报法证席/二、data-verifier数据包/三、竞争镜像席/四、多方陈词(bull)/五、空方陈词(bear)

---

# 【IDXX财报法证席报告·2026-07-24】

**席位**:门A深查·财报法证席(ADJ-0724-03四席之一)｜**档位**:Claude Fable 5(v1.19钢印)｜**战场**:焦点八问之1/2/5/7｜**纪律**:价盲(全程未取现价/目标价/估值倍数/市值)、一手件优先、勿凭印象

**取数说明(先声明证据链条,便于事后证伪)**:
- FMP MCP的`secFilings`/`earningsTranscript`端点受套餐限制被拒(ACCESS DENIED),**已降级为SEC EDGAR直连**(python3经代理·User-Agent合规),一手件全部落盘于scratchpad。
- 一手件核验清单:FY2025 **10-K**(申报2026-02-20·期末2025-12-31·accession 0000874716-26-000038)｜Q1 2026 **10-Q**(申报2026-05-05·期末2026-03-31·accession 0000874716-26-000076)｜Q1 2026 **8-K Exhibit 99.1**财报PR(申报2026-05-05·accession 0001104659-26-055203)｜**SDMA-into-CLIPs PR**(2026-05-19)｜**Fecal Dx绦虫PR**(2026-05-26)。
- **Q1 2026 earnings call transcript(2026-05-05)**原文页(Motley Fool/GuruFocus/InsiderMonkey/BusinessWire)经egress代理**403 Forbidden**无法直取,转述引文来自WebSearch对该transcript的检索摘录;凡transcript引文,**其数值均已用SEC 8-K一手件交叉印证**后方标"已证实",否则标"待核验"。

---

## 问1｜转换成本量化(仪器装机→耗材附着→软件绑定)——本节为核心

### 1A. 合同结构:多年期承诺+试剂租赁+IDEXX 360的口径原文【已证实】

10-K术语表与收入确认附注(Note 3, F-15/F-16)给出合同机制原文:

- **Customer commitment arrangements**(客户承诺安排):"Customer contractual arrangements that provide customers incentives in exchange for **multi-year commitments to purchase annual minimum amounts** of products and services."(10-K术语表,2026-02-20)
- **Reagent rentals**(试剂租赁):"Instruments being placed at customer sites at **little or no cost in exchange for a long-term customer commitment to purchase instrument consumables**."(同上)
- **IDEXX 360 / Free or Discounted Instruments**:"Many of our customer commitment arrangements, **such as our IDEXX 360 program**, provide customers with free or discounted instruments or systems upon entering into multi-year arrangements to purchase minimum annual amounts of products and services."(10-K Note 3, F-15)
- **IDEXX Points(预付激励+违约罚则)**:"We provide customers with incentives in the form of IDEXX Points upon entering into multi-year arrangements... **If a customer breaches their agreement, they are required to refund all or a portion of the up-front consideration**, or make other repayments, remedial actions, or both."(10-K Note 3, F-15)——违约退款条款=转换成本的合同化硬约束。

**razor-razorblade一手表述**:"We derive substantial revenues and margins from the sale of consumables that are used in IDEXX VetLab instruments, and **the multi-year consumable revenue stream is significantly more valuable than the placement of the instrument**."(10-K MD&A,2026-02-20)

### 1B. 转换成本的硬数字锚(合同化未来收入 + 已投入置换成本)【已证实】

| 指标 | 2025-12-31(10-K) | 2026-03-31(10-Q) | 出处 |
|---|---|---|---|
| **多年期承诺合同未满足履约义务·未来收入** | **≈$5.0 billion** | **≈$4.9 billion** | 10-K Note 3 / 10-Q Note 3 |
| — 确认节奏 | 28%/25%/22%/14%/11%(2026/27/28/29/此后) | 22%/26%/23%/15%/14%(余2026/27/28/29/此后) | 同上 |
| Contract asset(仪器收入应收未开票) | $312.7M(vs 2024:$246.3M) | — | 10-K Note 3 |
| Capitalized consideration paid to customers(预付客户激励资本化) | $250.1M(vs 2024:$196.6M) | — | 10-K Note 3 |
| Sales-type reagent rental lease receivable | $18.0M(vs 2024:$19.0M) | — | 10-K Note 3 |

**法证要点**:≈$4.9–5.0B是**合同化锁定的未来收入backlog**(客户已签约承诺购买、扣除预期返利与价格调整后的净额),非"印象中的黏性"。IDEXX为换取多年绑定已真金投入——contract asset $312.7M+资本化客户激励$250.1M合计逾$5.6亿资产挂账,这是转换成本"卖方侧成本"的量化证据。

### 1C. 装机基数与留存【已证实】

**Premium instrument装机表(单位:千台,期末)**(10-K MD&A):

| 仪器 | 2025-12-31 | 2024-12-31 | 2023-12-31 |
|---|---|---|---|
| Catalyst(化学) | 78 | 74 | 69 |
| Premium Hematology(血液) | 56 | 52 | 48 |
| SediVue Dx(尿液) | 24 | 21 | 18 |
| IDEXX inVue Dx(细胞) | 6 | 0 | 0(新平台) |

- **premium instrument装机基数同比+12%**(10-K:"12% growth in our installed base of premium instruments";10-Q同口径复述,2026-03-31)。
- **客户留存**:10-K/10-Q反复出现"continued high customer retention rates"/"high customer retention rates"(2026-02-20、2026-05-05,两处各自独立表述)。
- **留存量化(transcript,2026-05-05)**:"customer retention remains **in the high 90s**, reflecting the trust veterinarians place in IDEXX as both a diagnostics provider and long-term partner"——【待核验·transcript经聚合源转述】。此为公司给出的留存率量级(高90%区间),10-K未给精确百分数,故留存"高90s"精确值目前只能落到transcript口径。

### 1D. 软件-诊断工作流绑定(诊所管理系统嵌入)【已证实】

- **诊断信息中枢(cloud)**:"VetConnect PLUS is a **cloud-based technology that enables veterinarians to access and analyze patients' data from all of IDEXX's diagnostic modalities**... enables greater medical insight... through IDEXX DecisionIQ."(10-K Item 1)
- **IVLS捆绑销售**:"The IDEXX VetLab Station (IVLS) connects and integrates the diagnostic information from all the IDEXX VetLab analyzers... **We sell IVLS as an integral component for our point-of-care analyzer suite.**"(10-K Item 1)——诊断硬件天然绑定IDEXX的信息层。
- **PIMS(诊所管理系统)=SaaS订阅、结构性recurring**:"Animana, ezyVet, and IDEXX Neo practice management systems are **subscription-based SaaS offerings designed to provide flexible pricing and a durable, recurring revenue stream**... We also offer add-on subscription services, such as Pet Health Network Pro, **Vello**, Petly Plans, and credit card processing."(10-K MD&A)
- **影像PACS跨系统集成**:"IDEXX Web PACS is **integrated with Cornerstone, ezyVet, IDEXX Neo, and IDEXX VetConnect PLUS** to provide centralized access to diagnostic imaging results alongside patient records."(10-K Item 1)
- **transcript(2026-05-05)**:cloud-native PIMS装机双位数增长,"**virtually all placements now cloud-based**";管理层将"high 90s"留存归因于"the strength of our **integrated model, combining diagnostics, software and medical support**"——【待核验·transcript转述】。

### 1E. 平台嵌入·SDMA并入Catalyst CLIPs(prep焦点·2026-05-19一手PR)【已证实】

IDEXX PR(BusinessWire/IDEXX IR,2026-05-19,标题"IDEXX SDMA Now Integrated into the Most Common Catalyst Chemistry Profiles"):
- "SDMA... will be **built into Catalyst CLIPs, making complete kidney function evaluation part of the most common point-of-care chemistry profiles**."
- "Available **beginning in June to customers in the United States and Canada**, the integration expands access... **without disrupting familiar workflows**."(工作流零切换=嵌入而非叠加)
- 累计规模:"Since introducing the IDEXX SDMA Test in 2015, IDEXX has performed **approximately 119 million SDMA patient tests globally**."
- "Results are **seamlessly integrated into VetConnect PLUS**, alongside other diagnostic data."

**法证要点**:SDMA(肾病生物标志物,IDEXX原创)从参考实验室/单项测试**下沉嵌入POC最常用化学套餐**,把一个高价值专有测试变成Catalyst日常工作流的默认组成——这是"仪器装机→专有菜单→工作流锁定"链条加深的一手证据,直接回应prep问1的"Catalyst CLIPs平台嵌入"。

### 1F. 菜单加深·Fecal Dx绦虫检测自动并入(2026-05-26一手PR)【已证实】

IDEXX PR(BusinessWire/IDEXX IR,2026-05-26):
- "Beginning in late June, Fecal Dx antigen testing panels and profiles for IDEXX Reference Laboratories customers in the U.S. and Canada will **automatically include detection of taeniid tapeworm at no additional cost**."
- 规模:"Since launching in 2012, **more than 50 million Fecal Dx antigen tests** have been run worldwide."

**法证要点**:免费自动并入既有panel=以菜单广度提升单客户测试密度、抬高竞品复制门槛,属转换成本的"菜单锁定"维度。

### 1G. 关键试剂/供货绑定的双刃披露·Ortho至2044(与问7交叉)【已证实】

见问7节引用——Ortho供Catalyst化学slides至2044,既是IDEXX供应稳定的护城河支撑,也是其对单一外部供应商的关键依赖。

---

## 问2｜经常性收入口径 + CAG递归增速的价量拆分

### 2A. 10-K中"recurring revenue"定义原文与占比【已证实】

- **定义**:"Revenues from our IDEXX VetLab consumable products, our SNAP rapid assay test kits, outside reference laboratory and consulting services, and extended maintenance agreements and accessories related to our CAG Diagnostics instruments are considered recurring in nature."(10-K MD&A)
- **占比精确值**:"For the year ended December 31, 2025, **recurring diagnostic revenue, which is both highly durable and profitable, accounted for approximately 79% of our consolidated revenue**."(10-K MD&A,2026-02-20)

**口径要点(法证边界)**:该79%口径为**recurring _diagnostic_ revenue**(仅CAG诊断口径)。软件侧的**veterinary software recurring revenue**(Q1 2026为$73.5M/季)在10-K中另行列示、**未并入此79%**;因此"广义合并经常性收入占比"应高于79%,但**IDEXX未在一手件披露单一合并recurring%数值**。凡外部引用"recurring占比",须锁定是诊断口径79%还是含软件的更宽口径——公司只给了前者。

### 2B. Q1 2026 CAG递归收入拆分表(10-Q Note 3 disaggregation)【已证实】

三个月截至2026-03-31 vs 2025(单位:千美元):

| 类别 | 2026 | 2025 | 报告增速 | 有机增速 | 汇率贡献 |
|---|---|---|---|---|---|
| **Total CAG Diagnostics recurring revenue** | **920,313** | **806,267** | **+14.1%** | **+11.0%** | +3.1% |
| — IDEXX VetLab consumables | 412,582 | 344,779 | +19.7% | +15.4% | +4.2% |
| — Rapid assay products | 84,938 | 84,034 | +1.1% | **−0.1%** | +1.2% |
| — Reference lab diagnostic & consulting | 386,179 | 344,406 | +12.x% | — | +2.5% |
| — CAG Dx services & accessories | 36,614 | 33,048 | — | — | +3.6% |
| CAG Dx capital – instruments(非递归) | 42,449 | 31,994 | +33% | +28% | — |
| Vet software recurring(另计) | 73,536 | 65,793 | +12% | +11% | — |
| Vet systems & hardware(非递归) | 17,754 | 15,782 | — | — | — |

### 2C. 价与量的拆分口径与定性归因【已证实(定性)/关键缺口(定量)】

- **公司拆分口径**:IDEXX将增速分解为**报告增速 = 有机增速 + 汇率 + 并购**;**价与量合并落在"有机"内,不单独给net price vs volume数值**。
- **定性归因原文**(10-Q MD&A,2026-05-05):"The increase in revenue primarily reflected growth in CAG Diagnostics recurring revenue, including **higher volumes and the benefit from higher realized prices**. Volume growth was supported by new business gains, our expanded menu of available tests, and **high customer retention rates**."
- **量的支撑**:"Volume gains were supported by increases in testing across major regions, reflecting the benefits from **12% growth in our installed base of premium instruments** and growth in testing by existing customers."(10-Q)
- **价的独立信号(rapid assay,最能读出价量对冲)**:8-K PR原文"Rapid assay products revenues increased 1%... driven by **net price benefits with volume continuing to be impacted from the growing adoption of the Catalyst Pancreatic Lipase Test**, which continues to shift some testing across modalities."(2026-05-05)——即rapid assay有机−0.1%=正净价被负量抵消,量的流失是IDEXX自家Catalyst平台内部替代(利好整体,不利单品),非份额外流。

**关键缺口**:**IDEXX不单独量化net price与volume的贡献百分比**(只提供汇率%与有机%,价量捆绑在有机内)。故"CAG递归增速的价/量精确拆分"在一手件中**无法取得数值**,只能做方向性判断:量为主(装机+12%、菜单扩展、新客),价为辅且为正(higher realized prices反复出现)。此为问2的证据天花板。

---

## 问5｜资本配置(增量资本流向 + 回报口径)

### 5A. 研发投入(内生增量资本)【已证实】

10-K:R&D费用 **$251.2M(占收入5.8%)·2025** / $219.8M(5.6%)·2024 / $191.0M(5.2%)·2023——**R&D强度逐年上行**,是IDEXX增量资本的首要去向(新平台inVue Dx、Cancer Dx、AI影像等)。

### 5B. 资本开支(capex)【已证实,但席令所举"西德州新厂"未获一手件佐证——见缺口】

- 投资活动净流出:**$136.2M(2025)** vs $207.1M(2024);2024偏高系"acquisition of a software business during the prior year"(10-K)。
- PP&E购置:2025年约$1.28亿(现金流量表),Q1 2026为$31.984M。
- **2026 projected capex ≈$180M**,用途原文:"capital investments in **manufacturing and operations facilities to support growth, as well as investments in customer-facing software development**."(10-K MD&A;8-K PR指引表"Capital Expenditures ~$180")

**⚠️ 纪律警示(勿凭印象·反向证伪)**:席令问5示例列有"**西德州新厂**"。本席在一手件中**未发现任何Texas设施**——10-K Item 2 Properties主设施表为:Westbrook ME(总部+CAG制造)、Scarborough ME(Water/LPD/供应链)、Memphis TN、North Grafton MA、West Sacramento CA、Kornwestheim DE+海外(荷/瑞/法/英),`"texas"`在10-K全文出现次数=**0**;WebSearch亦未检出IDEXX任何德州/Texas建厂公告。**结论:席令的"西德州新厂"应视为未经证实的illustration,不得当作IDEXX既有事实**;IDEXX的capex披露是笼统的"制造与运营设施+面向客户软件开发",未点名任何新厂选址。

### 5C. 股东回报(回购为主·零股息)【已证实·8-K交叉印证】

- **回购(现金流量表)**:FY2025 repurchases of common stock **$1,216,964K(≈$1.22B)** vs $837.0M(2024)vs $71.9M(2023);Q1 2026公开市场回购成本 **$360,833K(588千股)**(8-K PR)。
- **授权**:董事会累计授权回购至多**78,000,000股**(自1999-08-13起多次上调),截至2025-12-31剩余**3,722,170股**,无到期日(10-K Item 5)。
- **零股息**:"**We have never declared or paid any cash dividends on our common stock.**"(10-K Item 5)——股东回报=100%回购+内生再投资,无股息成分。收益来源三分解中的"股息"项对IDEXX恒为零。
- **自由现金流**:Q1 2026 FCF **$234.3M** vs $207.9M(8-K,与transcript $234M一致);FCF转化指引85–95%净利。
- **杠杆**:0.6x gross / 0.5x net(transcript 2026-05-05,【待核验·transcript转述】)。

### 5D. 并购取向(轻并购·重内生)【已证实】

2024收购一软件业务(拉高当年investing outflow);Q1 2026 acquisitions仅**$2.6M**(8-K现金流量表)。IDEXX资本配置=**内生研发+capex+大额回购**为主轴,并购为辅、体量小。

### 5E. 管理层"增量投资回报"原话【待核验——一手transcript被403拦】

管理层对增量投资回报(ROIIC/reinvestment economics)的**逐字原话未能取得**:可访问的Q1 2026 earnings call transcript一手页经egress代理403 Forbidden;WebSearch surfaced仅到定性表述("reinvestment in innovation across diagnostic platforms"),**无明确增量资本回报率口径**。**如实标注:管理层ROIIC原话=未能取得一手件确认**,留待门A他席或后续补取。

---

## 问7｜(e)确定性价值损坏事件核查(专利/独家协议/诉讼/监管)

### 7A. 专利悬崖【已证实:无集中悬崖;SDMA专利梯次公司未披露=无法证实有无】

- **核心原文**:"While we consider ownership of these intellectual property rights in the aggregate to be important to us, **we do not believe that any single patent, copyright, trademark, trade secret, or license is material to our business as a whole**, and we primarily rely on the **innovative skills, technical expertise, customer focus and knowledge, and marketing abilities of our employees**."(10-K Item 1)
- **缓释因子(公司列举)**:同行评审第三方研究、品牌与声誉、产品服务整合广度、既有客户关系与服务、销售队伍、在线自动补货平台、监管批准状态、持续创新与菜单扩展等(10-K)。
- **SDMA/关键试剂专利到期梯次**:一手件**未见任何SDMA或关键试剂专利的具体到期日披露**。这与"无单一专利material"的表述自洽,且SDMA slides为**内制**(不在下述sole/single-source清单)并正深度嵌入CLIPs。**可证实=公司称无单一专利对整体material;不可证实=公司主动不披露专利到期梯次,故无法断言"有"或"无"SDMA专利悬崖**——如实标待核验。

### 7B. 独家/供货协议到期梯次【已证实】

- **Ortho(关键Catalyst化学slides)至2044**:"Certain Catalyst chemistry slides are supplied by **Ortho-Clinical Diagnostics, Inc. under supply agreements that are currently set to expire in December of 2044**. In the event of a notice of non-extension, the agreements will continue for a period of **twelve years**... We are **obligated to purchase all of our requirements for our current menu of Catalyst chemistry slides from Ortho**... The agreements also **prohibit Ortho from promoting and selling these chemistry slides in the veterinary sector, excluding the EU, other than to IDEXX**."(10-K Item 1)——**双刃**:护城河侧=对手拿不到同款slides(除EU)、协议超长且含12年缓冲;风险侧=IDEXX对Ortho单一供应商的关键依赖。
- **其他analyzer/consumable供货协议至2034**(可选延期,含最低采购义务)。
- **sole/single-source清单**:certain Catalyst Dx/One consumables(电解质及fructosamine、thyroxine、canine CRP、progesterone、SDMA、Pancreatic Lipase、Cortisol、Bile Acid slides**除外**)、ProCyte Dx、inVue Dx cytology consumables、SediVue Dx等。公司称已"successfully ensured uninterrupted supply"。

### 7C. 诉讼【已证实:无在诉material,一桩已了结】

- **Item 3 Legal Proceedings原文**:"we are at times subject to pending and threatened legal actions that arise out of the ordinary course of business. In the opinion of management... **the disposition of any such currently pending or threatened matters is not expected to have a material effect** on our results of operations, financial condition, or cash flows."(10-K Item 3)
- **一桩已了结**:"During 2025, we paid approximately **$80 million, which was accrued in prior years, to conclude a litigation matter**."(10-K MD&A现金流讨论)——已了结、非在诉。
- Q1 2026 10-Q Part II Item 1无新增material诉讼披露。

### 7D. 监管(FDA/USDA/EPA)【已证实:无未决损坏事件】

产品受FDA/USDA/EPA及多国监管,10-K风险因子为常规性表述,**未披露任何具体在诉/未决的损坏性监管或FDA-USDA执法事件**。

### 7E. 已宣布未生效的损坏性事件【已证实:未发现;附一治理succession】

- **未发现**任何已宣布未生效的价值损坏性事件(无专利裁决、无重大召回、无独家协议突然终止)。
- **附·管理层succession(治理事件,非价值损坏)**:transcript(2026-05-05)显示CEO **Jay Mazelsky**称此为其最后一次财报电话,**Mike Erickson接任**——【待核验·transcript转述;一手locus为DEF 14A(2026-03-27)及相关8-K,本席未逐字取证】。登记为"已宣布的管理层变更",供门A他席判其对护城河牢固度的含义。

---

## 法证席小结

### 转换成本量化证据强度自评:**强**(多重一手硬数据交叉印证,非印象)

支撑该评级的六根硬锚:
1. **合同化未来收入backlog ≈$4.9–5.0B**(多年期承诺未满足履约义务,10-K/10-Q Note 3)——最硬的锁定证据,合同数字而非叙事;
2. **已投入置换成本 contract asset $312.7M + 资本化客户激励 $250.1M**(公司为换取多年绑定的真金支出);
3. **装机基数 +12% / Catalyst 78千台**且逐年递增(razor);
4. **留存"高90s"**(transcript)叠加10-K/10-Q反复"high customer retention rates"(razorblade黏性);
5. **软件-诊断工作流集成**(VetConnect PLUS云中枢 + IVLS捆绑 + PIMS SaaS + Web PACS跨系统集成)+ **SDMA嵌入Catalyst CLIPs**(2026-05-19)+ Fecal Dx绦虫自动并入(2026-05-26)——嵌入而非叠加;
6. **razor-razorblade经济一手表述**:"multi-year consumable revenue stream is significantly more valuable than the placement of the instrument"。

### 关键缺口(供后续席/TL补强或标注不确定性)

1. **价量不单独量化**:IDEXX只披露汇率%与有机%,net price vs volume捆绑在"有机"内,CAG递归增速的价/量精确拆分**无一手数值**,仅能定性(量为主、价为正辅)。
2. **广义合并recurring%无单一披露**:公司只给"recurring diagnostic revenue ≈79%"(纯诊断口径),软件recurring另计,合并口径公司未给数。
3. **管理层ROIIC/增量投资回报原话未能取得**:一手transcript页403被拦,只余定性转述,无回报率口径。
4. **⚠️ 席令"西德州新厂"capex示例在一手件中零对应**:IDEXX无任何Texas设施(properties表为ME/TN/MA/CA+海外,`texas`全文0次;WebSearch亦无建厂公告)。该示例应作**未证实illustration**处理,不得当IDEXX事实入卷——此为"勿凭印象"纪律的实点。〔CGM落卷注:该illustration系CGM派发席令时之瑕疵示例,非GM prep锚内容——prep案卷问5原文无此项;法证席按纪律证伪,如实入卷。〕
5. **SDMA/关键试剂专利到期梯次公司主动不披露**:只可证实"公司称无单一专利material",无法证实专利悬崖之"有无",标待核验。
6. **留存"高90s"精确值仅transcript口径**:10-K/10-Q只给定性"high",未给精确百分数,该数值置信度依赖transcript(经聚合源转述,已与8-K其他数字交叉印证以佐可信度,但留存率本身无8-K对应可印证)。

—— 法证席报告完 ｜ 财报法证席(门A·ADJ-0724-03)｜2026-07-24 ｜ 全部数字均标出处与日期,拿不到者已如实标"未能取得一手件"
【IDXX数据包·門A深查·核实日2026-07-24】

标的:IDEXX Laboratories, Inc.(NASDAQ: IDXX,SEC CIK 0000874716,财年=日历年)
核实时点:2026-07-24(UTC),所引财务数据均为SEC已存档文件之定案数,非盘中数据;本包依价盲纪律不含任何现价/市值/估值/共识评级数据
主源:SEC EDGAR XBRL companyfacts(data.sec.gov,取数2026-07-24)+ 10-K/10-Q/8-K原文;财报电话会引文=Quartr Transcripts(经Bigdata.com检索,2026-07-24)
工具链偏离申报:FMP MCP之statements/calendar端点对本会话套餐全部返回ACCESS DENIED(2026-07-24实测,income-statement/cashflow/balance-sheet/earnings-company共6次调用均拒),按数据链降级至SEC EDGAR一手源;idexx.com、cloudfront(IR文档托管)、fool.com、stockanalysis.com被会话代理封锁(tunnel 403),Earnings Snapshot PDF原件不可达,相应数据以电话会转录与SEC存档新闻稿替代取得

---

## 一、多年财务窗(FY2019-FY2025+FY2026 Q1)

**营收与增速(报告口径;有机口径=公司非GAAP,剔汇率与并购)**
FY2019 | 营收$2,406.9M·报告+8.8%·有机+10.3%(汇率-1.8%/并购+0.2%) | 10-K FY2019(2020-02-14)
FY2020 | 营收$2,706.7M·报告+12.5%·有机+12.0%(并购+0.5%) | 10-K FY2020(2021-02-12) | 2020年4月CAG诊断经常性单月约-16%,6月约+30%
FY2021 | 营收$3,215.4M·报告+18.8%·有机+16.4%(汇率+1.6%/并购+0.8%) | 10-K FY2021(2022-02-16)
FY2022 | 营收$3,367.3M·报告+4.7%·有机+7.4%(汇率-3.4%/并购+0.7%) | 10-K FY2022(2023-02-16)
FY2023 | 营收$3,661.0M·报告+8.7%·有机+8.8%(汇率-0.2%/并购+0.1%) | 10-K FY2023(2024-02-22)
FY2024 | 营收$3,897.5M·报告+6.5%·有机+6.4%(汇率-0.3%/并购+0.4%) | 10-K FY2024(2025-02-21)
FY2025 | 营收$4,303.7M·报告+10.4%·有机+9.6%(汇率+0.8%) | 10-K FY2025(2026-02-20,acc 0000874716-26-000038)
FY2026 Q1 | 营收$1,140.8M·报告+14.3%·公司披露+14%报告/+11%有机(汇率+3.1%) | 10-Q Q1'26+8-K EX-99.1(2026-05-05) | 与prep锚一致

**利润率(报告口径;计算值=XBRL原始数相除)**
FY2019 毛利率56.7%·营业利润率23.0%·净利率17.8% | FY2020 58.0%/25.7%/21.5% | FY2021 58.8%/29.0%/23.2% | FY2022 59.5%/26.7%/20.2% | FY2023 59.8%/30.0%/23.1% | FY2024 61.0%/29.0%/22.8%(G&A含$61.5M诉讼计提) | FY2025 61.8%/31.6%/24.6%(Q1约$9M诉讼计提回冲) | FY2026 Q1 毛利率63.4%(公司口径+90bps)·营业利润率31.8%(+10bps报告/+100bps可比)·净利率24.4%(含$5M股权投资损失)

**FCF(=OCF−capex,XBRL)**
FY2019 $459.2M−$155.0M=$304.2M(12.6%) | FY2020 $648.1−$107.0=$541.1M(20.0%) | FY2021 $755.5−$119.5=$636.0M(19.8%) | FY2022 $543.0−$148.8=$394.1M(11.7%) | FY2023 $906.5−$133.6=$772.9M(21.1%) | FY2024 $929.0−$120.9=$808.1M(20.7%) | FY2025 $1,181.8−$124.7=$1,057.1M(24.6%·内含约$80M前期计提诉讼款支付) | FY2026 Q1 $266.2−$32.0=$234.3M(上年同期$207.9M)

**EPS(摊薄)**:FY2019-25:$4.89/$6.71/$8.60/$8.03/$10.06/$10.67/$13.08(FY2025 +23%报告/+14%可比·含约7%诉讼基数效应);Q1'26 $3.47(+17%报告/+15%可比·含+$0.14汇率/+$0.09股权激励税益/−$0.05股权投资损失)

---

## 二、分部与经常性收入

**CAG分部占比**:FY2019 88.0%→FY2021 89.9%→FY2023 91.6%→FY2025 91.9%($3,953.3M/$4,303.7M;Water $201.1M 4.7%/LPD $131.8M 3.1%/Other $17.5M)→Q1'26 92.4%(CAG报告+14.6%/有机+11.6%)

**经常性收入占比**:公司定义原文(10-K FY2025)="VetLab耗材+SNAP快检+外部参考实验室与咨询服务+CAG仪器延保与配件";**FY2025 recurring diagnostic revenue≈79%合并营收**(精确3,407.199/4,303.702=79.2%·不含软件);加计兽医软件经常性$276.3M后=85.6%(拼装计算·非官方口径);Q1'26 CAG诊断经常性$920.3M=80.7%总营收

**CAG诊断经常性年度序列(报告/有机)**:FY2019 $1,828.3M·+10.5%/+11.9% | FY2020 $2,113.8M·+15.6%/+14.8% | FY2021 $2,534.6M·+19.9%/+18.1% | FY2022 $2,660.3M·+5.0%/+8.2% | FY2023 $2,935.4M·+10.3%/+10.5% | FY2024 $3,129.5M·+6.6%/+6.8% | FY2025 $3,407.2M·+8.9%/+8.1%

**FY2025 CAG细项(报告/有机)**:VetLab耗材$1,496.8M·+14.8%/+13.7%;快检$349.0M·−3.0%/−3.3%;参考实验室$1,424.1M·+6.6%/+5.9%;服务配件$137.4M·+5.4%/+4.5%;仪器资本$200.2M·+51.8%/+49.3%;软件/影像$345.9M·+10.6%/+10.2%(其中经常性$276.3M·+10.4%/+9.9%)
**Q1'26 CAG细项(报告/有机)**:耗材$412.6M·+19.7%/+15.4%;快检$84.9M·+1.1%/−0.1%;参考实验室$386.2M·+12.1%/+9.7%;服务配件$36.6M·+10.8%/+7.2%;仪器$42.4M·+32.7%/+28.0%;软件/影像$91.3M·+11.9%/+10.9%

**CAG诊断经常性·近8季价/量拆分(电话会口径·Quartr转录)**
Q2'24:全球+7%有机;净价5-5.5%(美国低端);美国就诊量-1.8%;留存97%+
Q3'24:全球+7%有机(含约1%天数益);净价约5%·美国约4%;就诊量-2.1%
Q4'24:全球+7%有机;净价4-4.5%·美国约3.5%;美国量增约2%(天数标准化);溢价约800bps;FY2024全年净价约5%
Q1'25:全球+4.5%有机(剔1.5%天数逆风);净价4%·量约+2%;就诊量-2.6%
Q2'25:全球+7.5%有机;净价约4%;就诊量-2.5%·溢价约800bps
Q3'25:全球+10%有机;净价4-4.5%;美国净价4%+量增为主;就诊量-1.2%·溢价约950bps;留存high 90s
Q4'25:全球+10%有机;净价约4%;美国+9%=净价约4%+量约+5%;就诊量-1.7%·溢价约1,100bps
Q1'26:全球+11%有机(含约50bps天数益);净价约4%;美国近11%;就诊量约-1%·溢价约1,100bps;2026指引上调"all volume driven"(CFO原文)

---

## 三、ROIC双口径(FY2019-FY2025)

公式:NOPAT=营业利润×(1−有效税率);IC(年末)=信贷借款+长债+经营租赁负债+股东权益−现金;有形IC=IC−商誉−净无形;ROIC=NOPAT/平均IC。全分量XBRL。
分量(年末$M):总债务 FY2018 1,000.7→FY2025 847.8;经营租赁 0→128.2;股东权益 −9.5→1,605.4;现金 123.8→180.1;商誉 214.5→414.0;净无形 41.8→109.8
IC(年末):867.4/1,157.6/1,251.4/1,576.5/1,637.2/2,098.0/2,294.0/2,401.4;有形IC:611.1/859.4/955.5/1,118.2/1,177.8/1,647.5/1,777.2/1,877.5

FY2019 税率18.08%·NOPAT $452.9M | 报告ROIC 44.7% | 有形ROIC 61.6%
FY2020 12.06%·$610.7M | 50.7% | 67.3%
FY2021 17.48%·$769.1M | 54.4% | 74.2%
FY2022 21.03%·$709.7M | 44.2% | 61.8%
FY2023 20.37%·$873.7M | 46.8% | 61.8%
FY2024 20.00%·$902.7M | 41.1% | 52.7%
FY2025 19.99%·$1,088.1M | 46.3% | 59.5%
事实注记:FY2018年末股东权益−$9.5M(历年回购累计所致),早年分母受此影响,分量表已全给可按替代口径复算。

---

## 四、ROIIC多窗(v1.1)

3年窗 FY2022→FY2025:ΔNOPAT $378.4M/ΔIC $764.2M=**49.5%**(有形口径54.1%)
5年窗 FY2020→FY2025:ΔNOPAT $477.4M/ΔIC $1,150.0M=**41.5%**(有形51.8%)
**增量资本三桶(FY2021-25累计·现金流量表)**:有机capex $647.6M(14.1%)/并购净现金$261.6M(5.7%·FY2023与FY2025为0)/回购$3,692.4M(80.2%);股息=0(从未派息);同期累计FCF $3,668.2M,回购/FCF=100.7%;Q1'26单季回购$351.0M

---

## 五、装机与平台绑定(公司披露)

高端仪器装机(10-K FY2025装机表):Catalyst 78,000(2025)/74,000(2024)/69,000(2023);Premium Hematology 56,000/52,000/48,000;SediVue 24,000/21,000/18,000;inVue Dx 6,000(2025上市);四类合计164,000/147,000/135,000(+11.6%/+8.9%计算;公司口径+12%/+9%,舍入差)
装机增速逐季:Q2'25 +10%、Q3'25 +10%、Q4'25 +12%、Q1'26 +12%;国际连续11季双位数
FY2024投放约18,500台;inVue节奏:Q1'25 >300→Q2'25近2,400→Q3'25 >1,700→Q4'25 >1,900(另近1,400台竞争性转换Catalyst)→Q1'26 1,100台;FY2026计划5,500台
耗材vs装机:FY2025耗材有机+13.7% vs 装机+12%;Q1'26耗材+15.4% vs 装机+12%(公司无"耗材/台"披露口径)
留存:97%+(Q2'24)/>97%(Q3'24)/high 90s(Q3'25)
多年期协议未来收入逐年:FY2020约$2.2B→FY2021约$2.9B→FY2022约$3.2B→FY2023约$3.8B→FY2024约$4.4B→**FY2025约$5.0B**(确认节奏28%/25%/22%/14%/11%);IDEXX 360签约占比未披露
软件:云原生PIMS=ezyVet/Neo/Animana;Cornerstone本地基盘;附加=Vello(2024-02发布)/PHN Pro/Petly/Web PACS;Q4'25/Q1'26软件影像经常性有机+13%/+10.7%;Q1'26影像装机创纪录
Cancer Dx:北美客户近5,000家(2025-10·Q3'25会);2026国际上市

---

## 六、资产负债表

Senior Notes面值$450M($75M·3.72%·2026-09/$75M·3.72%·2027-02/$100M·4.19%·2029-03/$75M+$125M·2.50%·2030-04);信贷$1.0B循环(2030-11)+$250M Term Loan(2028-11),2025-12-31余额$398.0M·加权5.3%,2026-03-31 $530.0M
净债务/EBITDA:FY2024 0.46x;FY2025 0.44x($667.8M/$1,505.2M);2026-03-31 0.50x(TTM);契约≤3.5x合规
经营租赁$128.2M(2025-12-31);回购FY2021-25:$746.8/819.7/71.9/837.0/1,217.0M+Q1'26 $351.0M;授权余约3.7M股;摊薄股数FY2019 87.54M→FY2025 81.03M(−7.4%);从未派息;现金$180.1M(2025-12-31)/$200.5M(2026-03-31)

---

## 七、行业量:美国兽医就诊量(同店·同比)

IDEXX自报近8季:Q2'24 −1.8%|Q3'24 −2.1%|Q4'24约−3%|Q1'25 −2.6%|Q2'25 −2.5%|Q3'25 −1.2%|Q4'25 −1.7%|Q1'26约−1%(连续第三季−1%至−2%区间)
年度:2022 −2.3%;2023 −0.5%;2024 −2%;2025 −1.9%;2025诊断收入/店+约6% vs 诊所总收入+约2%;诊断溢价从约800bps(2024)升至约1,100bps(Q4'25/Q1'26)
公司2026假设:初始约−2%→Q1后中点约−1.5%
第三方交叉(Vetsource约6,500家·2026-01白皮书):2022 −3.5%;2023 −1.4%;2024 −2.6%;2025 −3.1%(wellness −3.8%)——面板口径不同,并列不裁决

---

## 八、指引对表(FY2026)与Q2财报日

初始(2026-02-02):营收$4,632-4,720M(有机+7.0-9.0%);CAG诊断经常性报告+8.6-10.6%/有机+8.0-10.0%(净价约4%);营业利润率32.0-32.5%;EPS $14.29-14.80
**Q1后更新(2026-05-05)**:营收$4,675-4,760M(报告+8.6-10.6%/**公司整体有机+7.7-9.7%**),中点+$42M;**CAG诊断经常性报告+9.6-11.6%/有机+8.7-10.7%**(净价约4%);营业利润率32.1-32.5%;EPS $14.45-14.90(+11-14%)
Q2財報日确认:**2026-08-04盘前**·电话会8:30 ET(公司公告2026-07-01+IR日历)——判定冻结deadline 2026-08-03成立

## 【未取到】(已试来源逐条)
1. PIMS各产品客户数(10-K/8-K/转录/web均无);2. 单台耗材收入或官方attach-rate(无此披露口径);3. IDEXX 360签约占比;4. FY2025全年净价单一值(仅区间4-4.5%);5. Q4'24就诊量精确小数(仅"nearly 3%");6. Earnings Snapshot PDF原件(代理403);7. FMP第二机器源(套餐ACCESS DENIED)——已以SEC XBRL/SEC新闻稿/电话会转录三重交叉替代。

## 【新旧冲突】(并列不裁决)
① **prep锚"CAG诊断经常性报告9.6-11.6%·有机7.7-9.7%" vs 8-K原文:7.7-9.7%=公司整体有机;CAG诊断经常性有机=8.7-10.7%**(报告口径两处一致;有机口径归属主体不一致)
② 美国就诊量IDEXX自报 vs Vetsource:2025 −1.9% vs −3.1%;2024 −2% vs −2.6%;2023 −0.5% vs −1.4%;2022 −2.3% vs −3.5%(面板/同店定义不同)
③ prep锚毛利率62.1%(Yahoo·TTM口径) vs SEC:FY2025 61.8%/Q1'26 63.4%/TTM重算62.05%——口径TTM vs 财年,相符
④ Q2'24就诊量同会CFO"−1.8%" vs CEO"2% decline"(舍入)
⑤ FY2024营收$3,897.5M(SEC定案) vs 二手源$3,899M(不采)
⑥ 装机增速公司口径+12%/+9% vs 表内加总+11.6%/+8.9%(舍入)

——数据包完(data-verifier·ADJ-0724-03数据包席·2026-07-24;工作文件与calc.py备查于容器scratchpad)
# 【IDXX竞争镜像席报告·2026-07-24】

**席位**:護城河研究员(第10席)·IDXX門A深查·竞争镜像席(ADJ-0724-03四席流程)
**运行档位申报**:Claude Fable 5(v1.19钢印·与派发核对一致)
**取证纪律**:价盲执行完毕——全程未接触IDXX现价/目标价/估值倍数/市值;证据三级置信标注:【A】=公司申报/披露一手件(10-K/10-Q/8-K/官方新闻稿),【B】=第三方数据或行业研究估计,【C】=媒体转述(含电话会transcript的媒体转录)。取数路径备案:FMP statements/transcript端点被订阅档位拦截,主证据改走SEC EDGAR原文(更优);idexx.com/q4cdn/avma.org/businesswire等域被代理403,该部分依赖检索转述并降级标注为【C】。

---

## 一、问3:竞争镜像一手实证

### 3(a) Zoetis诊断线——实际规模、增速与侵蚀证据

**营收序列(一手·已证实)**——Zoetis"Animal health diagnostics"产品类别(含伴侣动物+畜牧诊断,POC仪器/耗材/快检/参考实验室服务/血糖仪):

| 年度 | 营收 | 同比 | 来源 |
|---|---|---|---|
| FY2021 | $374M | — | ZTS FY2023 10-K(2024-02-13申报)【A】 |
| FY2022 | $353M | -5.6% | 同上【A】 |
| FY2023 | $376M | +6.5% | ZTS FY2025 10-K(2026-02-12申报)【A】 |
| FY2024 | $386M | +2.7% | 同上【A】 |
| FY2025 | $434M | +12.4% | 同上【A】 |
| Q1 2026 | $117M | +12.5% yoy | ZTS 10-Q(2026-05-07申报)【A】 |

- **规模对比锚**:Zoetis整条诊断线FY2025 $434M = IDEXX CAG诊断经常性收入$3,407M的**12.7%,约1:8**;仅IDEXX参考实验室单项($1,424M)就是Zoetis整条诊断线的3.3倍。诊断占Zoetis总营收($9,467M)仅4.6%——对Zoetis是边缘业务,对IDEXX是命脉。【A】
- **产品线进展(一手)**:2018年收购Abaxis获Vetscan POC组合;Vetscan Imagyst逐年加AI应用(2023 AI皮肤病学+AI马粪便;2024 AI尿沉渣+**Vetscan OptiCell**卡匣式AI血液学分析仪;2025 AI Masses肿瘤细胞检测);2025年收购**Veterinary Pathology Group(VPG,英+爱参考实验室集团)**——ZTS 10-K原文明示"did not have a material impact"(商誉仅增约$43M),但方向上标志Zoetis首次进入IDEXX参考实验室腹地。【A】
- **挫折史(一手)**:ZTS 10-K注脚确认2022年诊断存货与资产减值、2023年"精准动物健康与诊断"资产减值——其诊断攻势2021-2024实际停滞(四年累计仅+3.2%,CAGR约0.8%)。【A】
- **近期加速归因(混合)**:Q1 2026电话会(2026-05-06):伴侣动物诊断$113M、+10%,驱动=参考实验室扩展+化学/血液学(OptiCell拉动)【C】;10-Q:国际分部增长含"small animal diagnostics",Corporate费用上升部分因"higher expenses in global diagnostics"(仍在加投入)【A】。
- **对IDEXX份额的实际侵蚀证据:未找到**。判定依据:①2022-2025三年IDEXX CAG诊断经常性+28.1% vs Zoetis诊断+22.9%(低基数+含VPG小并购),四年窗Zoetis近零增长而IDEXX累计+40%+;②2025-2026双方同步加速——"诊断渗透率共同抬升"而非零和转移;③IDEXX同期装机与净新客户扩张(见问8)。结论:**已证实=Zoetis在成长;未证实=Zoetis在从IDEXX手中夺量**。OptiCell对inVue Dx构成"未来POC血液学/细胞学正面交锋",目前证据只支持"并行增长"。

### 3(b) Mars Science & Diagnostics体系(Antech+Heska+SYNLAB Vet)

**交易事实链(一手·已证实)**:
- 2023-03-31签约:收购方法律实体=**Antech Diagnostics, Inc.**(Mars任Parent),对价**$120.00/股现金**(Heska并购8-K,2023-04-03)【A】;交易总额约**$1.3B**(AVMA口径,与股本推算吻合;流传"$3.7B"不实)【B】;2023-06-13完成,并入Mars Petcare Science & Diagnostics【A】。
- 2023-09-29:Mars再收**SYNLAB Vet**(欧洲专科兽医实验室)【A】;德国诊所软件商**VetZ**(Heska 2022-01收购,$12.2M/年)随体系并入【A】。

**Heska被购前底牌(一手·FY2022 10-K,2023-02-28)**:FY2022营收**$257.3M**(+1.4%),**经营亏损$20.3M**——被购时不盈利;北美60%/国际40%;北美POC线$95.5M(+9.9%);资产=Element系列POC分析仪/Element AIM/scil渠道/trūRapid前身/VetZ;**定价行为关键证据:Heska长期订阅合同内置年度提价条款=max(4%, CPI)**——其商业模式同样是"锁定+年度提价",不是低价破坏者。【A】

**合并后体系能力(拼图)**:参考实验室(Antech=北美最大网络之一)+POC仪器耗材(Element线)+快检(trūRapid)+影像远程放射(AIS/RapidRead)+软件(VetZ)+癌筛(Nu.Q授权)——结构上唯一能对IDEXX"仪器-实验室-软件"三位一体全线对标的体系【B】;叠加Mars自有诊所**约3,000家**(Banfield约1,000+/VCA约1,000+/BluePearl约100+)【B】——**垂直整合是Mars体系与Zoetis的本质差异:自带需求端**。IDXX FY2025 10-K风险因素对应确认:企业化诊所与采购联盟集中议价、"若大型企业主决定把采购转给竞争者"是已披露风险【A】。
- **诊所渗透与定价行为(2024-2026)**:Antech产品攻势=RapidRead Dental(AI牙科影像,犬2025-05/猫2026-01)、trūRapid FOUR(2025-03)、**SDMA上其院内平台Element i+**(VMX 2026·2026-01-13官宣·<3分钟定量;SDMA此前已在Antech参考实验室提供)【A】;CoreChem改名并定位"practical, cost-effective"(性价比措辞)【A·营销口径】;**2026年价目**:2025-12-01发布、2026-01-01生效之年度调价,AIS影像价格"冻结至另行通知"【A·官网】。
- **降价抢份额的一手证据:未找到**。观测到:Antech照常年度调价(方向未披露,"调价+影像冻结"更接近选择性提价而非全面价格战);性价比定位停留营销层;Heska遗产合同自带提价条款。**关键盲区:Mars私有无财报,Antech对企业客户的合同折扣(bundling)行为无法从公开渠道证实或证伪——本席最大取证缺口**。
- **SDMA信号跨问交叉**:SDMA已非IDEXX独占标志物——Antech参考实验室已提供、2026年推向院内平台;IDEXX应对=SDMA嵌入Catalyst CLIPs(2026-05-19,prep在案)。独家性梯次此点位实际已让渡,竞争转入"平台嵌入深度"维度。

### 3(c) 其余玩家一句话级扫描【B】

Mindray动物医疗(中国,二线性价比切入低价段)/Fujifilm(三线POC生化)/Esaote/Boule/Woodley(三线设备)/Virbac(法,诊断为辅)/Bionote(韩,快检)/bioMérieux(2025-06马呼吸道PCR利基)/Thermo Fisher/Neogen/Bio-Rad/Charm/BioChek/Innovative Diagnostics(主战LPD/水务——IDXX 10-K列为Water与LPD分部竞对,非伴侣动物核心盘【A】)/AI诊断初创(SignalPET等,X光AI判读,未见一手侵蚀数据)。

### 3(d) 市场份额多源估计(全部第三方【B】·口径不一,不可相加)

| 细分 | 估计 | 来源/置信 |
|---|---|---|
| 伴侣动物诊断(整体) | IDEXX"接近半个市场" | Science & Medicine/Kalorama转述【B】 |
| 第一梯队排序 | IDEXX第一、Mars(Antech+Heska)第二、Zoetis第三 | 多份行研一致【B】 |
| 全球兽医参考实验室 | 前5大>50%,IDEXX与Mars并列领先 | MarketsandMarkets【B】 |
| 兽医POC诊断 | 前5大约半;IDEXX/Zoetis/Heska(Antech)领衔 | Mordor/GrandView/Precedence【B】 |
| POC市场规模(2025) | 约$2.23B,CAGR约9.6-10.4%至2030 | 同上(彼此有出入)【B】 |
| 终端结构 | 兽医院所占2024年约53% | GrandView【B】 |

**镜像席独立提示**:一手财报交叉验证行研定性排序——IDEXX参考实验室单项($1,424M)+VetLab耗材($1,497M)数量级碾压Zoetis整条诊断线($434M)与Heska被购前($257M)。真正同数量级的只有Mars/Antech体系(私有无法精确,叠加约3,000家自有诊所+SYNLAB+Antech网络=唯一结构性对手)。**可信结论=IDEXX稳居第一约半壁;唯一体量级对手是Mars,非Zoetis。**

---

## 二、问4:威胁三分类取证

### ②型(需求结构/周期疲软)——证据充分、已证实

美国同店兽医就诊量连续多年负增长,行业级需求疲软,**非IDEXX独有、非竞争夺量**:

| 年度 | IDEXX自报美国同店就诊量 | 行业口径(Vetsource) | 来源 |
|---|---|---|---|
| 2023 | 约-0.5% | -1.4% | IDXX FY2023 10-K【A】/Vetsource【B】 |
| 2024 | 约-2% | -2.6% | IDXX FY2024 10-K【A】/Vetsource【B】 |
| 2025 | 约-2% | -3.1%(wellness -3.8%) | IDXX FY2025 10-K【A】/Vetsource 2026-01白皮书(约6,500家)【B】 |
| Q1 2026 | 约-1%("modest easing") | — | Q1新闻稿+电话会【A/C】 |

- IDEXX归因:"veterinary practice capacity challenges"+宏观逆风;2026展望预设同店仍类似下滑【A】。
- 行业交叉:2025全国诊所营收+约2.5%而就诊-约3%,"增长越来越靠提价而非量"【B/C】;超半数宠主曾跳过推荐诊断/疫苗/手术【B】。
- **②型判定:成立且强**——"看病的人少了",周期+结构(宠主价格敏感、就诊间隔拉长约48%),需求侧,非IDEXX失守。

### ①型(竞争定价压力/被抢份额)——候证微弱、未证实

- **未找到任何一手证据**表明Zoetis或Antech以系统性降价从IDEXX夺份额;
- 反向证据:IDEXX FY2025持续实现约4%全球净价改善,毛利率不降反升(Q4 2025 +50-60bp、Q1 2026 +90bp,归因含net price realization)【A】——若有价格战,提价+扩利难以持续;
- Antech公开定价=年度调价+影像冻结,Heska遗产合同自带max(4%,CPI)提价——竞对自身也在提价;
- **唯一①型候证**:IDXX 10-K风险因素自陈"竞争者以更低价格推销较弱产品"长期存在、企业化诊所/采购联盟集中议价压利润【A】——结构性议价压力,非当前正在发生的夺量事件。

**问4结论**:当前疲软**主体是②型,①型证据微弱**。量的疲软是全行业周期,而IDEXX在此周期中仍提价、仍扩份额(问8),疲软未转化为粘性流失。

---

## 三、问6:集中度standing输入

**IDEXX营收结构(FY2025 10-K)**【A】:CAG $3,953M=**91.9%**(有机+9.8%)/Water $201M=4.7%(+8.0%)/LPD $132M=3.1%(+6.1%)/Other $17M。

- **集中度画像**:≈92%系于单一终端(伴侣动物),其中CAG诊断经常性$3,407M占约79%总营收——终端集中度极高。
- **对照(竞对更分散)**:Zoetis伴侣约70%/畜牧约29%(FY2025 10-K)【A】有畜牧对冲;Mars动保只是巨型集团一角,极度分散且自带需求端。
- **standing记法建议**:IDEXX高集中度是**"深"而非"散"**——全部筹码押在增长最优质、经常性最强、粘性最高的细分,换来同业最高有机增速质量与净价能力;代价=缺对冲,若伴侣动物终端结构性坍缩(非当前周期性疲软)无第二腿。"聚焦溢价"与"单一终端脆弱性"一体两面,应作对照项明记,非单纯扣分项。

---

## 四、问8:就诊量疲软期"跌价不跌份额"T2雏形(一手)

**价(净价实现)**【A+C】:FY2024全球净价约4-4.5%·美国约3.5%(初始指引约5%,大客户续约让利)【C】;FY2025全球约4%(区间下沿)【C】,毛利率仍扩张(Q4 +50-60bp·归因含net price realization)【A】;Q1 2026毛利率63.4%·+90bp【A】;2026指引再预设约4%【A】。**判定:就诊量连续负增长三年,IDEXX每年稳定提价约4%且被接受(高保留率下)——价端毫无松动**。

**量与份额**【A】:装机base连续三年+约12%/年(Catalyst 69→74→78千台等);CAG诊断经常性有机FY2023约+9%→FY2024 +7%→FY2025 +8%→Q1 2026 +11%;净新客户:FY2025 Q4"net customer gains"+参考实验室"new customer acquisition"+Q4"nearly 1,400 new and competitive Catalyst placements"(**competitive placements=从竞对夺装机**)【A】;保留率"high-nineties"【C】+10-K"continued high customer retention rates"【A】;美国增速"outpacing sector growth levels"(跑赢行业=疲软行业中扩份额)【A】。

**问8结论:T2雏形不仅"有",而且已相当成熟**。三年就诊下行段同时做到:①年提价约4%不松动;②装机+12%/年(含competitive placements);③经常性有机中高个位数并Q1'26回升两位数;④保留率高九十几;⑤明确跑赢行业。**跌的是行业就诊量(②型),IDEXX既没跌价也没跌份额,反而夺装机、扩客户**——转换成本护城河在压力测试下价格权+粘性双双未损。

---

## 五、镜像席小结

### ②型威胁——充分、已证实、当前主导
2023-2025就诊量连续负增长(公司自报与Vetsource双向交叉),Q1 2026现缓和迹象;全行业周期+结构,非IDEXX失守。置信高。

### ①型威胁——微弱、未证实、当前非主导
Zoetis体量1:8、四年停滞、无夺量一手证据;Mars/Antech=唯一结构性对手(垂直整合+自带约3,000家诊所)但公开定价行为非价格战;IDEXX提价4%+毛利扩张+装机+12%+competitive placements+保留率高90s**反向证伪"正在被价格战夺份额"假说**。

### 关键缺口(诚实登记)
1. **Mars/Antech私有无财报**——对企业化诊所的合同折扣/bundling(①型最可能隐藏形态)无法证实或证伪,本席最大盲区,建议risk-devil陪审明记"不可观测的下行尾部";
2. 份额为第三方估计,无一手精确数;"约半壁"口径不一;
3. 电话会精确措辞依赖媒体转录【C】(官方PDF被代理403),关键数字已由8-K/10-K【A】交叉锚定;
4. OptiCell/inVue Dx正面交锋结果未知(均2024-2025新推),需2026-2027数据,目前仅"并行增长、未见此消彼长"。

### 供TL综合的镜像席判断(仅证据陈述,不出裁决)
当前威胁主体=②型(需求周期)而非①型(竞争夺量);IDEXX三年疲软压力测试呈成熟"跌行业量、不跌自身价与份额"形态,转换成本护城河与净价权未见受损。持续盯防两点=Mars/Antech垂直整合长期威胁(合同折扣不可观测)+OptiCell/inVue Dx POC正面交锋——均"未来跑道上的问号",非"当前失守的证据"。

---

**主要一手来源【A】**:IDXX 10-K FY2023/24/25(2024-02-22/2025-02-21/2026-02-20)、10-Q Q1'26(2026-05-05)、8-K FY2025(2026-02-02)与Q1'26(2026-05-05);ZTS 10-K FY2023/FY2025(2024-02-13/2026-02-12)、10-Q Q1'26(2026-05-07);Heska 10-K FY2022(2023-02-28)与并购8-K(2023-04-03)。**【B/C】**:Vetsource 2026-01白皮书(转述)、AVMA/dvm360/Mars/Antech新闻稿(转述)、行研多家、电话会媒体转录。

**分歧点(尤其①型"未证实"与Mars私有盲区)请勿调和,原样呈报。**
【IDXX門A深查·多方陈词·2026-07-24】

**席位申报**:多方研究员(bull)·ADJ-0724-03互盲双席之多方·Claude Fable 5(v1.19钢印)。信息来源仅限证据包四件:prep案卷、财报法证席报告(下称"法证")、data-verifier数据包(下称"数据")、竞争镜像席报告(下称"镜像")。价盲纪律已执行:全文无价格/估值/市值/目标价,不出任何仓位与买卖建议。凡电话会转录口径之数字随注"电话会口径";证据包内"待核验/【B】/【C】"标注原样随引,未升格使用。

---

## ① MDG档位主张:5档(五级量表最高档;证据下限护栏=4档)

**主张**:IDEXX护城河牢固等级应评**5档**。本席操作性读数:4档=机制在场+经济足迹持续;5档=机制在场+经济足迹持续+**压力实测通过**+**锁定深度仍在加深**。本案四条全中。若TL对不可观测尾部(Mars合同折扣盲区,见⑥⑦)从重扣分,证据下限亦稳在4档——任何低于4档的判定,需要解释为何推翻下述已观测的全部压力测试证据。

**沟的形状**:双主沟+一副沟的深沟结构。MedTech尺的"仪器-耗材-软件"原型(prep§一:v16.77域裁直接适用)在本案以教科书强度完整在场:

**1. 转换成本(主沟·证据强度:强)**——四层互锁,层层有一手硬数:
- **合同层**:多年期承诺未满足履约义务**≈$5.0B**(2025-12-31)/≈$4.9B(2026-03-31),附IDEXX Points**违约退款罚则**;确认节奏28/25/22/14/11%,即约47%在2028年及以后确认(法证§1A/1B)。backlog由FY2020约$2.2B逐年增至FY2025约$5.0B(数据§五);同期营收$2,706.7M→$4,303.7M(数据§一)。**本席由包内数计算**:backlog五年+127% vs 营收+59%,合同锁定/年营收之比从约0.81x升至约1.16x——**沟相对业务体量在加深,且按可审计的时间表加深**。
- **资产层**:contract asset **$312.7M**+资本化客户激励**$250.1M**,合计逾$5.6亿挂账(法证§1B)。
- **装机层**:高端仪器装机135千台(2023)→147千台(2024)→**164千台(2025)**,公司口径+12%;Catalyst 69→74→78千台(法证§1C/数据§五)。
- **工作流层**:IVLS捆绑、VetConnect PLUS云中枢、PIMS SaaS、Web PACS跨系统集成(法证§1D);10-K自证razor-razorblade原文(法证§1A)。留存:10-K/10-Q两处独立"continued high customer retention rates"(已证实·定性);97%+/high 90s为电话会口径(数据§五;法证§1C标待核验)。

**2. 无形资产(副主沟·中强)**:SDMA累计约**1.19亿次**检测,2026年6月起并入Catalyst CLIPs、"without disrupting familiar workflows"(法证§1E·2026-05-19一手PR);Fecal Dx累计逾**5,000万次**,绦虫免费自动并入(法证§1F·2026-05-26 PR);Ortho化学slides独家供应至**2044年12月**+通知不续仍延12年+禁Ortho外售兽医渠道(除EU)(法证§7B)。诚实边界:公司自陈无单一专利material、SDMA专利梯次未披露(法证§7A·待核验)——本沟支柱=菜单嵌入+累计数据+独家供应+品牌,非专利墙,本方不作专利主张。

**3. 成本/规模优势(副沟·中强)**:参考实验室单项**$1,424.1M**=Zoetis整条诊断线的**3.3倍**(镜像§一3(a));R&D强度5.2%→5.8%逐年上行(法证§5A);毛利率**56.7%(FY2019)→61.8%(FY2025)→63.4%(Q1'26)**而年净价仅约4%——超出提价幅度的利润率扩张=规模与组合经济的观测足迹。

**4. 网络/数据效应(弱·仅辅助)**:VetConnect PLUS+DecisionIQ、1.19亿SDMA样本解读积累。更近数据规模优势,本方不以此为档位支柱。

**经济足迹封底**:ROIC连续七年报告41.1-54.4%/有形52.7-74.2%,FY2025=46.3%/59.5%(数据§三);ROIIC三年窗**49.5%**(有形54.1%)、五年窗41.5%(数据§四)。

---

## ② 观测证据闸(已观测机制证据逐项清单·硬闸判定)

1. ≈$5.0B合同化backlog+违约退款条款;逐年序列$2.2B→$5.0B(数据§五)。
2. 卖方侧绑定投入$312.7M+$250.1M挂账(法证§1B)。
3. 装机基数三年135k→147k→164k(+12%),逐季+10%/+10%/+12%/+12%(数据§五)。
4. Q4'25近**1,400台**"new and competitive" Catalyst placements——从竞对转换装机之公司披露(镜像§四【A】/数据§五)。
5. **八季净价序列约4-5.5%全程为正、无一季松动**,同期美国就诊量八季全负(数据§二/§七)。
6. 诊断溢价约800bps(2024)→约1,100bps(Q4'25/Q1'26);2025每店诊断收入+约6% vs 诊所总收入+约2%(数据§二/§七)。
7. 留存:10-K/10-Q定性(已证实)+97%+/high 90s(电话会口径)。
8. SDMA并入CLIPs已官宣6月供货、Fecal Dx免费自动并入——已落地的菜单嵌入事件(法证§1E/1F)。
9. Rapid assay有机−0.1%拆解:净价正、量流向自家Catalyst(8-K原文)——平台内迁移非份额外流(法证§2C)。
10. 七年ROIC双口径+两窗ROIIC+Q1'26毛利率63.4%。
11. 竞争不对称观测:Zoetis诊断2021-2024累计仅+3.2%、两度减值;Heska被购前营收$257.3M、经营亏损$20.3M(镜像)。

**硬闸判定:≥1项已观测机制证据——本案十一项超额通过。**

---

## ③ 焦点八问逐问表态

**问1**:有且多重硬数交叉:$5.0B backlog、$562.8M绑定投入、违约退款条款、四层工作流绑定。法证自评"强",采认。
**问2**:recurring diagnostic≈79%(官方精确79.2%),加软件拼装约85.6%(非官方,标注引用);增速质量=价辅(约4%)量主且走强:Q4'25美国+9%≈价4%+量5%,Q1'26有机+11%八季最高、上调"all volume driven"(电话会口径)。价量官方精确拆分不存在=在案证据天花板。
**问3**:Zoetis体量1:8、四年停滞后再加速、无夺量一手证据、"并行增长";Mars/Antech唯一同量级,可观测定价=年度调价+影像冻结,Heska遗产max(4%,CPI)条款——对手也在提价,非价格战。
**问4**:②型成立主导、①型微弱被反向证据压制,详④。
**问5**:ROIIC 49.5%/41.5%;三桶=capex 14.1%/并购5.7%/回购80.2%、回购/FCF=100.7%——低资本消耗高回报是合同化模式特征非缺陷;跑道:inVue首年6,000台+FY2026计划5,500台、Cancer Dx近5,000家+2026国际、国际装机连续11季双位数。管理层ROIIC原话未取得(待核验),不引不脑补。
**问6**:CAG 91.9%/92.4%。采镜像"深而非散"记法:筹码集中于经常性最强净价力最强终端=溢价经济之源;对照项如实记,终端结构性坍缩观测证据为零——溢价反走扩。
**问7**:无在诉material、无未决监管损坏、无已宣布未生效损坏;Ortho至2044+12年;SDMA专利梯次不可知(待核验)、CEO交接=治理监测项。
**问8**:不止雏形——"已相当成熟"(镜像§四):三年负增长期年净价4%不松、装机+12%含竞争性转换、留存高位、美国跑赢行业。采认并以此为5档核心依据。

---

## ④ 威胁三分类定性

**①型**:候证微弱、未证实。三重反向观测:(a)八季净价正+毛利率扩张——价格战下难并存;(b)竞对自身在提价;(c)Q4'25竞争性装机近1,400台**流入**。唯一结构性候证=10-K自陈企业化诊所议价风险——风险登记项非正在发生事件。Mars合同折扣不可观测→记risk-devil监测尾部;**"不可观测"不得充作"正在发生"**。
**②型**:成立、主导、已证实——就诊量2022 −2.3%/2023 −0.5%/2024约−2%/2025 −1.9%/Q1'26约−1%(八季最温和),Vetsource并列在案。**定性:②型打击宿主变量,IDEXX在②型压力中的表现恰是护城河测试通过证明**——溢价800→1,100bps、每店诊断+6% vs 诊所+2%、上调"all volume driven"、2026量假设仍保守。②型是压力测试,不是护城河伤口。
**③型**:Ortho单一供应依赖(2044+12年超长表尾)/CEO交接(待核验)/SDMA专利梯次不可知——均无已观测损坏,入监测清单非扣档依据。

---

## ⑤ 三色认知初判倾斜

**错杀leaning。概率感:错杀约65%/合理约30%/失守≤5%。**

理由:疲软叙事的全部事实基础(就诊量、UBS下调)均属②型宿主变量;护城河自身全部可观测指标(净价/留存/装机/竞争性转换/溢价/backlog/有机增速Q1'26 +11%八季最高)**全部同向走强**。叙事读宿主,沟读价与份额:错配即"错杀leaning"定义域。失守≤5%依据:失守应有足迹(留存下行/净价松动/装机停滞/竞争性流失)在四件证据中零出现。Stifel Buy vs UBS Neutral=该认知分歧的市场镜像。
**纪律注**:价盲下"叙事vs实态"初判,不构成估值/价格判断;错杀带另案、判定后刷价。

---

## ⑥ 预防性回应(steelman空方三最强)

**攻击一:"Mars垂直整合自带约3,000家诊所,合同折扣不可观测——'无①型证据'只是看不见。"**
回应:(i)承认盲区,但盲区≠证据,只能入监测清单;(ii)若折扣战在咬合,IDEXX侧必留足迹——实际:留存高位、净价八季不松、竞争性装机流入、跑赢行业;(iii)可观测对手周边证据全反向(Antech选择性提价/Heska遗产提价条款/被购时亏损$20.3M/多实体整合期);(iv)风险因子登记多年而T2证据仍在累积。建议:留存/净价/竞争性装机/企业账户动向四哨兵指标交risk-devil长期盯防——监测设计问题,非当期档位问题。

**攻击二:"SDMA独家性已让渡、Zoetis再加速、OptiCell对撞inVue——沟边缘剥落。"**
回应:(i)**标志物可得性≠工作流对等**:IDEXX把SDMA下沉为78,000台Catalyst默认组成、零切换、无缝入VetConnect PLUS——竞争被拖入IDEXX主场;1.19亿次解读资产不随标志物开放转移;(ii)Zoetis加速建立在1:8体量+四年停滞低基数上;镜像明判"未证实夺量"、并行增长;诊断占Zoetis 4.6%=边缘业务攻命脉业务;(iii)OptiCell vs inVue胜负未知如实承认;现观测=inVue首年6,000台,在位者节奏未乱。

**攻击三:"增长靠提价,就诊量在缩、逾半宠主跳过推荐诊疗,4%年提价迟早撞支付疲劳。"**
回应:(i)最新观测反向:Q4'25美国+9%中量约+5%>价约4%,Q1'26上调"all volume driven"——量引擎与就诊量部分脱钩(装机+12%与菜单加深驱动单次就诊诊断强度,即溢价机制);(ii)就诊量年序−2.3%→约−1%收敛非恶化,公司假设仍保守;(iii)"逾半宠主跳过"系【B】级且属②型宿主证据;护城河命题=价与份额保持,两者在场。支付疲劳若至,先撞无溢价能力的对手线。

---

## ⑦ 弱环自曝

1. **转录口径依赖**:留存精确值、八季价量拆分、"all volume driven"均电话会口径;官方仅定性。若转录失真,主沟"黏性与增长质量"数值层降为定性层(方向层仍有10-Q定性+装机+12%托底)。
2. **Mars盲区不可由我方关闭**:①型"无证据"部分处"无法观测"域;本方以IDEXX侧生命体征代偿论证=代理观测非直接观测——若Mars体系内约3,000家诊所静默内转量,公开渠道滞后显影。
3. **压力测试深度有限**:已观测②型为−1%至−3%温和多年下行,非深度衰退;5档主张中"极端压力下的沟"部分系温和压力实测外推——此为5档与4档之间最正当争议地带。

---

**多方最强一句话**:连续三年行业就诊量负增长的真实压力下,IDEXX同时做到年净价约4%不松、留存高位、装机年+12%并在Q4'25从对手转换近1,400台、诊断溢价从约800bps扩到约1,100bps、合同锁定收入从$2.2B加深到$5.0B——这条沟不是没被测过,而是**测过了,并且测出来在变宽**。

——多方陈词完(bull·ADJ-0724-03·2026-07-24·仅据证据包四件,逐数标席,价盲执行完毕)
【IDXX門A深查·空方陈词·2026-07-24】

席位:互盲双席之空方研究员(ADJ-0724-03)｜档位:Claude Fable 5(v1.19钢印申报)｜纪律申报:全程价盲(未接触任何现价/估值/市值数据),不出仓位与买卖建议;信息源仅限四件证据包(prep案卷/法证席/data-verifier/镜像席),互盲执行——未接触多方任何输出;凡证据包标"待核验/【C】/盲区"者,本陈词按原置信等级使用,不升格为实锤。

---

## ① MDG档位主张:3档(主张档);若TL认定观测闸已闭合,退守立场为4档下限+降级路径预登记;5档在任何读法下证据不足

**主张理由三根梁**:

**梁一:被读作"深沟"的量化锚,凡到关键处全是公司自述口径,SEC一手件里没有。**留存率"高90s"——法证席自曝(01·缺口6):10-K/10-Q只有定性"high customer retention rates",精确数值仅电话会转述,且"留存率本身无8-K对应可印证";价/量拆分——法证席明判(01·问2C):"价/量精确拆分在一手件中无法取得数值",data-verifier近8季净价4-5.5%序列(02·第二节)全部标注"电话会口径·Quartr转录"。护城河判定的两个核心KPI(粘性与定价权),没有一个落在申报文件里。用卖方自选口径量卖方的沟,系统性只会量深不会量浅。

**梁二:分板块透视,竞争烈度与增速严格负相关——"深沟"其实是一深两浅的加权平均。**FY2025 CAG经常性细项(02·第二节):VetLab耗材(Catalyst封闭系统,无直接竞争的razor-blade环)有机+13.7%;参考实验室(与Antech——"北美最大网络之一"——正面对垒的主战场)有机仅+5.9%,剪刀差7.8pp;快检(trūRapid在场+自家跨模态替代)有机−3.3%。参考实验室$1,424.1M占总营收33%,恰是Mars体系正面板块+Zoetis VPG新入侵点,其增速是耗材的四成。多方若把整体+8.1%读成护城河均匀纵深,是把唯一无对手的封闭环的高增速,摊到了有对手的三分之一营收上。真牢固的只是Catalyst耗材一环;MedTech尺下这不支撑4-5档的"体系级深沟"。

**梁三:所谓压力测试通过,测试期恰是竞争真空期。**镜像席一手确认:Zoetis诊断2021-2024四年累计仅+3.2%(其自身减值挫折),Heska 2023年中才并入Mars、随后是Antech+SYNLAB+VetZ多资产整合期。IDEXX"三年提价4%+装机+12%"的全部实证,都发生在唯一两个对手一个停滞、一个消化不良的窗口。真测试的发令枪2025-2026才响:Zoetis诊断FY2025 +12.4%、Q1'26 +12.5%(已快于IDEXX CAG经常性报告+8.9%);Antech SDMA院内平台2026-01官宣、OptiCell 2024推出。以真空期水位读沟深,是本案最大的时序错置。

---

## ② 观测证据闸攻击:逐项审"已观测机制证据"

1. **留存"高90s"=转述口径,非观测。**补一刀:留存率定义未披露(客户数留存还是收入留存?)——若收入口径,年净价+4%本身即可在客户量流失下维持"高90s"读数。应从"已观测"降为"公司声称"。
2. **净价约4%=电话会口径,非观测;且序列方向向下。**FY2024约5%→FY2025约4%(区间下沿)→FY2026指引约4%。更锋利的是美国:FY2024美国净价约3.5%,对初始指引约5%,缺口归因"大客户续约让利"【C】——定价权最强的叙事年份里,对企业化大客户实际让了价。此项内含一条已观测的定价权边际走弱序列。
3. **ROIIC 49.5%/41.5%读数≠再投资机器证据。**增量资本三桶:五年累计回购$3,692.4M占80.2%,回购/FCF=100.7%,有机capex仅14.1%。ΔNOPAT对应的"增量投入"八成是股票注销——读数证明的不是"每一块钱再投资赚回五毛",而是**公司找不到值得投的第二块钱**。管理层增量回报口径从未给出(01·5E)。双口径ROIC叠加分母注记:FY2018权益−$9.5M,回购长期压薄分母;趋势上有形ROIC从FY2021峰值74.2%回落至FY2024 52.7%、FY2025回升59.5%还含诉讼基数效应。高位、但峰值已过。
4. **"T2雏形成熟"依赖对手盘错置。**T2要证"对竞争者不跌价不跌份额",而镜像席自判①型"微弱未证实"——没有已证实的进攻方,测试对手盘其实是宠主;宠主判卷结果=就诊量四年连负。"跌行业量不跌自身价"更准确读法:向存量客户钱包挤压(诊断溢价800→1,100bps),不是对竞争者的防线验证。
5. **"competitive placements近1,400台"=单季单点,无定义无序列**,从谁转换、以何激励换来均未披露;同期绑定资产加速膨胀:contract asset +27.0%、资本化激励+27.2%,合计$5.6亿、增速约为营收(+10.4%)的2.6倍。装机+12%背后是**资产负债表在买锁定**,IDEXX 360签约占比恰未披露——买来的份额扩张,成色不能按自然粘性计。
6. **SDMA嵌入CLIPs按时序是防御,不是纵深。**Antech参考实验室早已供SDMA、2026-01-13官宣上院内Element i+,IDEXX 2026-05-19才并入CLIPs。独占标志物失守后免费打包进套餐=以让渡单项定价权换平台粘性;Fecal Dx"no additional cost"同构。护城河深的公司加菜单收钱,受压的公司加菜单免费。镜像已明记"独家性梯次此点位实际已让渡"——这是①型的已观测让渡,不是"未来问号"。
7. **Backlog≈$5.0B是全案最硬一锚,但久期被高估。**确认节奏28/25/22/14/11%——89%四年内确认,约合1.16年营收可见性;序列膨胀与激励资产同速同源:更多度量"合同化锁客的力度";合同粘性有到期日、有违约罚则——**需要罚则来留的客,和自愿留下的客,在MDG尺上不是一个等级**。
8. **"约半壁份额/跑赢行业"=第三方【B】拼图,口径互斥不可相加,不入观测闸。**

**闸结论**:剔除转述、单点与真空期外推后,真正过闸的已观测机制证据=装机表(SEC一手)+backlog(SEC一手)+利润率序列(XBRL)。支持"有实沟"(3档),不支持"深沟已验证"(4-5档)。

---

## ③ 焦点八问·空方逐问表态

**问1**:合同侧证据硬,但方向要读对——$5.6亿绑定资产以2.6倍于收入的速度膨胀,锁定越来越靠买;软件绑定规模证据缺失(PIMS客户数未取到;软件经常性仅占营收6.4%)。**沟真,深度存疑。**
**问2**:79%仅诊断口径,85.6%系拼装非官方;价量无一手数值,倒算FY2024量贡献仅约+1.8%(有机+6.8%−净价约5%)——低谷年增长几乎全靠价。**增长质量约一半系于价,而价的对手盘(宠主)正在退。**
**问3**:1:8是存量比不是动能比——Zoetis诊断增速已反超;Mars唯一同量级且私有不可观测;"无侵蚀证据"是观测能力陈述,不是格局陈述。
**问4**:见④——①型应改记"低可观测+已现三处雏形";②型应加记"转结构候证"。
**问5**:读数高企但八成增量资本是回购;内生再投资(R&D $251.2M+capex约$180M指引)相对FCF $1,057M体量偏小——跑道消化能力与"长跑道"叙事矛盾。
**问6**:单一终端占比88.0%→91.9%→92.4%仍在上升;对照Zoetis有29%畜牧对冲。"深而非散"是修辞化解,MedTech尺下应实扣:四年就诊量连负正是该终端结构风险的现在进行时。
**问7**:三处未闭合——Ortho全量采购义务至2044且排他条款"excluding the EU"(独家封锁有地理豁免,欧洲正是Mars/SYNLAB+VetZ地盘;现实威胁低但"独家性有缺口"是事实);SDMA专利梯次主动不披露而Antech已在供——分子层独占已实质终结;CEO交接落在竞争重启窗口(待核验)。
**问8**:真空期测试无效力(梁三);"价"的先行序列已软:净价5%→4-4.5%→4%,FY2026上调"all volume driven"——管理层自己收起了价杠杆。

---

## ④ 威胁三分类·反方定性(含预设死因与先行指标)

**①型:不是"微弱",是"低可观测性掩盖下已现雏形"。**Mars私有无财报,合同折扣/bundling"无法证实或证伪"(镜像自曝最大盲区);Mars自带约3,000家诊所——内部转单是股东指令,不需要公开降价动作,天然不可观测;IDXX 10-K自认"若大型企业主决定把采购转给竞争者"风险。把观测不到记为微弱=把探照灯没照到的水域记为没有礁石。已观测三处雏形在案:大客户续约让利压低美国净价;参考实验室板块增速仅为耗材四成;SDMA独占让渡。
**②型:转结构候证已强于"纯周期"定性。**四年连负(Vetsource口径更深至−3.1%);行为证据:超半数宠主跳过推荐诊断、就诊间隔拉长约48%;弹性实证:2020年4月单月−16%——宠物诊断是可延迟消费。IDEXX应对=量缩价补+菜单并入,把诊断溢价从800bps推到1,100bps:诊所总收入仅+2%的盘子里,诊断挤占份额有极限。此模式在**消耗需求曲线的存量弹性**,非等待周期回归。
**预设死因+先行指标**:死因A=②转结构、价引擎熄火:盯逐季净价跌破4%、就诊量恶化过−2.5%、诊断溢价bps见顶回落、快检类高弹性单品加速衰减(FY2025已−3.3%)。死因B=Mars/Zoetis在参考实验室显性化:盯参考实验室有机跌破5%、与耗材剪刀差扩大、VPG式收购再现。死因C=POC正面交锋失利:盯inVue季度投放(Q1'26仅1,100台=全年计划20%,上市放量以来最低单季;季节性未知,候证)、装机增速跌出双位数、"competitive placements"口径从电话会消失。
**③被忽略项**:CEO交接执行风险;Ortho依赖+EU豁免;**判定时点风险**——Q1'26(+11%,近8季最高)含约50bps天数益+对上弱基数(Q1'25 +4.5%),两年几何均速仅约7.7%,低于FY2023的+10.5%;prep在案Q2共识约+9%。判定冻结在动能单季高点上,顶点外推风险应明记。

---

## ⑤ 三色认知初判:失守leaning

概率感:**失守leaning约45% / 合理约45% / 错杀约10%**。此处"失守"指认知失守——若共识按4-5档深沟计,证据实况(一深两浅板块结构+真空期测试+关键锚非SEC口径)支持的是3档,即共识高于实况。不主张深度失守:backlog、装机序列、六年利润率扩张是真硬锚,排除2档以下。倾斜成因:2026年恰是三条压力线(Mars整合完成、Zoetis加速、SDMA院内竞品)同时通电的第一年,而全部乐观证据的截止日期都在通电之前。

---

## ⑥ 预防性回应:steelman多方最强三论点并拆解

**论点一"$5.0B backlog+高90s留存+违约罚则=同业罕见合同化转换成本"**——承认backlog为SEC一手。拆解:久期1.16年营收当量;留存数值不在SEC件;买锁定的资产端成本+27%/年、快于营收2.6倍;违约罚则的存在本身是自然粘性不足额的旁证。合同化锁定是真沟,但它是**需要持续付费维护的沟**,与"结构性深沟"差一个等级。
**论点二"三年负增长下年年提价4%、毛利扩张、装机+12%=压力测试通过"**——拆解:测试期=竞争真空期;提价对手盘是宠主而非竞对,宠主反制写在四年负就诊量与"跳过推荐诊断"里;净价序列5%→4-4.5%→4%递降、美国大客户已让利、FY2026上调"all volume driven"——**定价权在被使用中递减,管理层已自行降杠杆**。
**论点三"规模1:8、Zoetis四年攻不动、Mars无价格战证据、SDMA已反制"**——拆解:1:8是存量,动能上Zoetis已反超;"攻不动"的四年是其自身减值挫折期,证明它当年执行差,不是IDEXX不可攻;Mars"无证据"=不可观测,且其正面板块参考实验室恰是IDEXX增速最弱一环;SDMA进CLIPs时序在Antech官宣后四个月,是失守后的防御性打包。

---

## ⑦ 弱环自曝

1. **"竞争真空期"是时序推断,非因果实证。**Zoetis停滞归因其自身减值,无法证明"若其早发力IDEXX即失守";其重启加速仅两个报告期、低基数。若2026-2027 IDEXX在对抗期继续提价+双位数装机,本论点全塌。
2. **价量倒算的自反性。**一面攻击电话会口径不入观测闸,一面用同一口径净价数倒算"量弱"与两年均速7.7%——口径武器化双标;且装机+12%带动的量增长本可正读为razor引擎运转;"单台产出稀释"无一手,只能算方向性怀疑。
3. **Mars盲区论证是认知论证不是实证。**证据包内没有任何转单/折扣一手;反有间接反证:Mars收Heska后三年,IDEXX装机与经常性收入无任何减速痕迹,Q4'25还有近1,400台竞争性转换。若Mars长期按兵不动,"盲区=尾部风险"就是空转的审慎,TL应按"不可观测的下行尾部"记账,而非按已发生扣分。

---

**空方最强一句话**:这条沟最硬的几个读数——留存率、净价、ROIIC——没有一个写在SEC文件里,唯一同量级的对手连财报都没有,而全部"压力测试通过"的成绩单,签发日期都在对手进场之前;我们不是在量一条被验证过的深沟,是在用卖方的尺子、于竞争真空的水位线上,给一条只有Catalyst一环够深的沟批发"体系级深沟"的等级。

——空方陈词完(bear·ADJ-0724-03·2026-07-24)｜引据:prep案卷+01法证席+02data-verifier+03镜像席,未引入包外事实;盲区均按盲区申报,待核验项均保留原标注。
