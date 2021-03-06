import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';

class MyPageSet {
  void trySubmit() {
    formKey.currentState.validate();
  }

  void trySubmit1() {
    formKey1.currentState.validate();
  }

  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();

//查看合約
  void viewContract(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('合約內容'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Text(
                      '房屋租賃契約書',
                      style: TextStyle(
                          color: AppConstants.appBarAndFontColor,
                          fontSize: Adapt.px(40)),
                    ),
                    Text(
                      '''中華民國91年1月30日內政部台內中地字第0910083141號公告頒行
                        (行政院消費者保護委員會第86次委員會議通過)\n
                        中華民國105年6月23日內政部內授中辦地字第1051305386號公告修正 
                        (行政院消費者保護會第47次會議通過)\n契約審閱權\n
                        本契約於中華民國__年__月__日經承租人攜回審閱__日（契約審閱期間至少三日）
                        \n承租人簽章：\n出租人簽章：''',
                      style: TextStyle(fontSize: Adapt.px(25)),
                    ),
                    Text(
                      '房屋租賃契約書',
                      style: TextStyle(
                          color: AppConstants.appBarAndFontColor,
                          fontSize: Adapt.px(40)),
                    ),
                    Text('''
                        立契約書人承租人    ，出租人    【為□所有權人□轉租人(應提示經原所有權人同意轉租之證明文件)】茲為房屋租賃事宜，雙方同意本契約條款如下：

第一條 房屋租賃標的

 一、房屋標示：

(一)門牌__縣(市)__鄉（鎮、市、區）__街（路）__段__巷__弄__號__樓(基地坐落__段__小段__地號。)。

(二)專有部分建號__，權利範圍   ，面積共計  平方公尺。

 1.主建物面積：

__層__平方公尺，__層__平方公尺，__層__平方公尺共 計__平方公尺，用途__。

 2.附屬建物用途__，面積__平方公尺。

(三)共有部分建號   ，權利範圍   ，持分面積  平方公尺。

(四)□有□無設定他項權利，若有，權利種類：   。

(五)□有□無查封登記。

二、租賃範圍：

(一)房屋□全部□部分：第__層□房間   間□第  室，面積__平方公尺(如「房屋位置格局示意圖」標註之租賃範圍)。

(二)車位：

1.車位種類及編號：

地上(下）第__層□平面式停車位□機械式停車位，編號第__號車位＿個。

2.使用時間：

□全日□日間□夜間□其他___。(如無則免填)

(三)租賃附屬設備：

□有□無附屬設備，若有，除另有附屬設備清單外，詳如後附房屋租賃標的現況確認書。

(四)其他：   。

第二條 租賃期間

    租賃期間自民國  年  月  日起至民國  年  月  日止。

第三條 租金約定及支付

   承租人每月租金為新臺幣(下同)   元整，每期應繳納   個月租金，並於每□月□期  日前支付，不得藉任何理由拖延或拒絕；出租人亦不得任意要求調整租金。

租金支付方式：□現金繳付□轉帳繳付：金融機構：____，戶名：____，帳號：____。□其他：____。

第四條 擔保金（押金）約定及返還

擔保金（押金）由租賃雙方約定為___個月租金，金額為   元整(最高不得超過二個月房屋租金之總額)。承租人應於簽訂本契約之同時給付出租人。

   前項擔保金（押金），除有第十一條第三項、第十二條第四項及第十六條第二項之情形外，出租人應於租期屆滿或租賃契約終止，承租人交還房屋時返還之。

第五條 租賃期間相關費用之支付

租賃期間，使用房屋所生之相關費用：

一、管理費：

 □由出租人負擔。

 □由承租人負擔。

房屋每月    元整。

停車位每月   元整。

租賃期間因不可歸責於雙方當事人之事由，致本費用增加者，承租人就增加部分之金額，以負擔百分之十為限；如本費用減少者，承租人負擔減少後之金額。

□其他：      。

二、水費：

□由出租人負擔。

□由承租人負擔。

□其他：______。(例如每度  元整)

三、電費：

□由出租人負擔。

□由承租人負擔。

□其他：______。(例如每度  元整)

四、瓦斯費：

□由出租人負擔。

□由承租人負擔。

□其他：______。

五、其他費用及其支付方式：______。

第六條 稅費負擔之約定

本租賃契約有關稅費、代辦費，依下列約定辦理：

一、房屋稅、地價稅由出租人負擔。

二、銀錢收據之印花稅由出租人負擔。

三、簽約代辦費     元

□由出租人負擔。

□由承租人負擔。

□由租賃雙方平均負擔。

□其他：     。

四、公證費      元

□由出租人負擔。

□由承租人負擔。

□由租賃雙方平均負擔。

□其他：     。

五、公證代辦費      元

□由出租人負擔。

□由承租人負擔。

□由租賃雙方平均負擔。

□其他：     。

六、其他稅費及其支付方式：______。

第七條 使用房屋之限制

本房屋係供住宅使用。非經出租人同意，不得變更用途。

承租人同意遵守住戶規約，不得違法使用，或存放有爆炸性或易燃性物品，影響公共安全。

出租人□同意□不同意將本房屋之全部或一部分轉租、出借或 以其他方式供他人使用，或將租賃權轉讓於他人。

前項出租人同意轉租者，承租人應提示出租人同意轉租之證明文件。

第八條 修繕及改裝

房屋或附屬設備損壞而有修繕之必要時，應由出租人負責修繕。但租賃雙方另有約定、習慣或可歸責於承租人之事由者，不在此限。

前項由出租人負責修繕者，如出租人未於承租人所定相當期限內修繕時，承租人得自行修繕並請求出租人償還其費用或於第三條約定之租金中扣除。

房屋有改裝設施之必要，承租人應經出租人同意，始得依相關法令自行裝設，但不得損害原有建築之結構安全。

前項情形承租人返還房屋時，□應負責回復原狀□現況返還□其他_____。

第九條 承租人之責任

    承租人應以善良管理人之注意保管房屋，如違反此項義務，致房屋毀損或滅失者，應負損害賠償責任。但依約定之方法或依房屋之性質使用、收益，致房屋有毀損或滅失者，不在此限。

第十條 房屋部分滅失

    租賃關係存續中，因不可歸責於承租人之事由，致房屋之一部滅失者，承租人得按滅失之部分，請求減少租金。

第十一條 提前終止租約

本契約於期限屆滿前，租賃雙方□得□不得終止租約。

依約定得終止租約者，租賃之一方應於□一個月前□  個月前通知他方。一方未為先期通知而逕行終止租約者，應賠償他方___個月(最高不得超過一個月)租金額之違約金。

前項承租人應賠償之違約金得由第四條之擔保金(押金)中扣抵。

租期屆滿前，依第二項終止租約者，出租人已預收之租金應返還予承租人。

第十二條 房屋之返還

 租期屆滿或租賃契約終止時，承租人應即將房屋返還出租人並遷出戶籍或其他登記。

前項房屋之返還，應由租賃雙方共同完成屋況及設備之點交手續。租賃之一方未會同點交，經他方定相當期限催告仍不會同者，視為完成點交。

承租人未依第一項約定返還房屋時，出租人得向承租人請求未返還房屋期間之相當月租金額外，並得請求相當月租金額一倍(未足一個月者，以日租金折算)之違約金至返還為止。

    前項金額及承租人未繳清之相關費用，出租人得由第四條之擔保金(押金)中扣抵。

第十三條 房屋所有權之讓與

出租人於房屋交付後，承租人占有中，縱將其所有權讓與第三人，本契約對於受讓人仍繼續存在。

前項情形，出租人應移交擔保金（押金）及已預收之租金與受讓人，並以書面通知承租人。

本契約如未經公證，其期限逾五年或未定期限者，不適用前二項之約定。

第十四條 出租人終止租約

  承租人有下列情形之一者，出租人得終止租約：

一、遲付租金之總額達二個月之金額，並經出租人定相當期限催告，承租人仍不為支付。

二、違反第七條規定而為使用。

三、違反第八條第三項規定而為使用。

四、積欠管理費或其他應負擔之費用達相當二個月之租金額，經出租人定相當期限催告，承租人仍不為支付。

第十五條 承租人終止租約

出租人有下列情形之一者，承租人得終止租約：

一、房屋損害而有修繕之必要時，其應由出租人負責修繕者，經承租人定相當期限催告，仍未修繕完畢。

二、有第十條規定之情形，減少租金無法議定，或房屋存餘部分不能達租賃之目的。

三、房屋有危及承租人或其同居人之安全或健康之瑕疵時。

第十六條 遺留物之處理

租期屆滿或租賃契約終止後，承租人之遺留物依下列方式處理：

一、承租人返還房屋時，任由出租人處理。

二、承租人未返還房屋時，經出租人定相當期限催告搬離仍不搬離時，視為廢棄物任由出租人處理。

 前項遺留物處理所需費用，由擔保金(押金)先行扣抵，如有不足，出租人得向承租人請求給付不足之費用。

第十七條 通知送達及寄送

    除本契約另有約定外，出租人與承租人雙方相互間之通知，以郵寄為之者，應以本契約所記載之地址為準；並得以□電子郵件□簡訊□其他__方式為之(無約定通知方式者，應以郵寄為之)；如因地址變更未通知他方或因__，致通知無法到達時（包括拒收），以他方第一次郵遞或通知之日期推定為到達日。

第十八條 疑義處理

    本契約各條款如有疑義時，應為有利於承租人之解釋。

第十九條 其他約定

    本契約雙方同意□辦理公證□不辦理公證。

本契約經辦理公證者，租賃雙方□不同意；□同意公證書載明下列事項應逕受強制執行：

□一、承租人如於租期屆滿後不返還房屋。

□二、承租人未依約給付之欠繳租金、出租人代繳之管理費，或違約時應支付之金額。

□三、出租人如於租期屆滿或租賃契約終止時，應返還之全部或一部擔保金（押金）。

公證書載明金錢債務逕受強制執行時，如有保證人者，前項後段第__款之效力及於保證人。

第二十條 爭議處理

因本契約發生之爭議，雙方得依下列方式處理：

一、向房屋所在地之直轄市、縣（市）不動產糾紛調處委員會申請調處。

二、向直轄市、縣（市）消費爭議調解委員會申請調解。

三、向鄉鎮市(區)調解委員會申請調解。

四、向房屋所在地之法院聲請調解或進行訴訟。

第二十一條 契約及其相關附件效力

    本契約自簽約日起生效，雙方各執一份契約正本。

    本契約廣告及相關附件視為本契約之一部分。

    本契約所定之權利義務對雙方之繼受人均有效力。

第二十二條 未盡事宜之處置

    本契約如有未盡事宜，依有關法令、習慣、平等互惠及誠實信用原則公平解決之。

附件

□建物所有權狀影本

□使用執照影本

□雙方身分證影本

□保證人身分證影本

□授權代理人簽約同意書

□房屋租賃標的現況確認書

□附屬設備清單

□房屋位置格局示意圖

□其他（測量成果圖、室內空間現狀照片）

立契約書人

出租人：

姓名(名稱)：　　　　簽章

統一編號：

戶籍地址：

通訊地址：

聯絡電話：

負責人：         （簽章）

統一編號：

電子郵件信箱：

承租人：

姓名(名稱)：　　　　簽章

統一編號：

戶籍地址：

通訊地址：

聯絡電話：

電子郵件信箱：

保證人：

姓名(名稱)：　　　（簽章）

統一編號：

戶籍地址：

通訊地址：

聯絡電話：

電子郵件信箱：

不動產經紀業：

名稱（公司或商號）：

地址：

電話：

統一編號：

負責人：　　　　（簽章）

統一編號：

電子郵件信箱：

不動產經紀人：

姓名：　　　　 　（簽章）

統一編號：

通訊地址：

聯絡電話：

證書字號：

電子郵件信箱：

中華民國           年          月            日
                      ''')
                  ],
                )),
              );
            }),
          );
        });
  }

  //常見問題
  void commonProblem(BuildContext context) {
    bool q1 = false;
    bool q1Program1 = false;
    bool q1Program2 = false;
    bool q2 = false;
    bool q3 = false;
    bool q4 = false;
    bool q5 = false;
    bool q6 = false;
    bool q7 = false;
    bool q8 = false;
    bool q9 = false;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('常見問題'),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q1 = !q1;
                          });
                        },
                        child: Text(
                          'Q1.RENTPARADISE收費方式？',
                          style: TextStyle(
                              fontSize: 16,
                              color: q1 ? Colors.blue : Colors.black),
                        ),
                      ),
                      q1
                          ? Column(
                              children: <Widget>[
                                Text(
                                  '創建RENTPARADISE房源不需費用，後續透過平台管理租客(*收租/門禁/預繳電費) 等服務，依照服務項目進行收費。',
                                  style: TextStyle(fontSize: 14),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      q1Program1 = !q1Program1;
                                    });
                                  },
                                  child: Text(
                                    '簡單收租方案',
                                    style: TextStyle(
                                        color: q1Program1
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                ),
                                q1Program1
                                    ? Column(
                                        children: <Widget>[
                                          Text(
                                            '服務介紹\n7點/月/戶',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            '1. 租約管理\n*線上續約/合約到期續約提醒/完整租屋日期/續約/租客資訊...等\n2. 房租自動催繳\n*未繳款門鎖自動失效\n3. 詳細帳務報表\n*租客繳付房租即刻入帳',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      q1Program2 = !q1Program2;
                                    });
                                  },
                                  child: Text(
                                    '躺著管理方案',
                                    style: TextStyle(
                                        color: q1Program2
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                ),
                                q1Program2
                                    ? Column(
                                        children: <Widget>[
                                          Text(
                                            '服務介紹\n10點/月/戶',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            '1. 租約管理\n*線上續約/合約到期續約提醒/完整租屋日期/續約/租客資訊...等\n2. 房租自動催繳\n*未繳款門鎖自動失效\n3. 詳細帳務報表\n*租客繳付房租即刻入帳\n4. 電費預付儲值系統\n*租客儲值多少用多少/低餘額通知',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            )
                          : Container(),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q2 = !q2;
                          });
                        },
                        child: Text(
                          'Q2.如何新增房源?',
                          style: TextStyle(
                              fontSize: 16,
                              color: q2 ? Colors.blue : Colors.black),
                        ),
                      ),
                      q2
                          ? Column(
                              children: <Widget>[
                                Text(
                                  '''1.登入會員後，可在下方功能選單點選「房屋資訊」右上方 +按鈕來建立房源。\n2.新增房源包含以下步驟，分別說明如下：
o房源位置資訊：房源地址、房源類型、樓層、坪數、格局等基本資訊。
o照片描述：為房源撰寫標題及描述、上傳房源照片。介紹房源的特色、拍攝清楚的房源照片。
o家俱設備：房源提供的家具（如桌椅）及設備（如冷氣、冰箱），若您提供列表以外的家具及設備，請填寫並新增。
o房源守則：房源的居住守則，包含身份性別限制、房源使用限制等。
o收費價格：設定房源的押金、租金、水電費用(分一般電費與夏季電費)
預覽：完成以上步驟後，您可以預覽房源在RENTPARADISE的發佈頁面，再按下右上角「發佈房源」，即完成建立房源流程。''',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          : Container(),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q3 = !q3;
                          });
                        },
                        child: Text(
                          'Q3.電子租約有效力嗎？',
                          style: TextStyle(
                              fontSize: 16,
                              color: q3 ? Colors.blue : Colors.black),
                        ),
                      ),
                      q3
                          ? Column(
                              children: <Widget>[
                                Text(
                                  '''線上的電子租賃契約等同於房東與房客雙方合意之租賃憑證 ，效力等同於書面契約。民法並無要求租賃契約必須以書面契約進行，只要證明「租賃契約存在」即可。''',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          : Container(),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q4 = !q4;
                          });
                        },
                        child: Text(
                          'Q4.接受房客的簽約申請後，是否能修改租約內容？\n',
                          style: TextStyle(
                              fontSize: 16,
                              color: q4 ? Colors.blue : Colors.black),
                        ),
                      ),
                      q4
                          ? Column(
                              children: <Widget>[
                                Text(
                                  '''不能，接受簽約申請，視同雙方皆同意簽約，不可以修改租約內容。(可於續約時協議更改)''',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          : Container(),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q5 = !q5;
                          });
                        },
                        child: Text(
                          'Q5.房屋資訊中的「已出租、未出租」代表什麼意思？\n',
                          style: TextStyle(
                              fontSize: 16,
                              color: q5 ? Colors.blue : Colors.black),
                        ),
                      ),
                      q5
                          ? Column(
                              children: <Widget>[
                                Text(
                                  '''1.已出租：房客已完成簽約流程，目前正在您的房源中居住。
2.未出租：尚未出租的房源。''',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          : Container(),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q6 = !q6;
                          });
                        },
                        child: Text(
                          'Q6.要如何查看目前的所有租約？',
                          style: TextStyle(
                              fontSize: 16,
                              color: q6 ? Colors.blue : Colors.black),
                        ),
                      ),
                      q6
                          ? Column(
                              children: <Widget>[
                                Text(
                                  '''可至房屋資訊中的「已出租」中，點擊需確認的合約的房源，
至租客資訊頁中確認合約狀況。''',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          : Container(),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q7 = !q7;
                          });
                        },
                        child: Text(
                          'Q7.我的房客已經退租，要如何解除管理?\n',
                          style: TextStyle(
                              fontSize: 16,
                              color: q7 ? Colors.blue : Colors.black),
                        ),
                      ),
                      q7
                          ? Column(
                              children: <Widget>[
                                Text(
                                  '''可至房屋資訊中的「已出租」中，長按需解除管理的房源，
點選「解約房客」。''',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          : Container(),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q8 = !q8;
                          });
                        },
                        child: Text(
                          'Q8.若房源已發佈，是否可以修改房源相關資訊，例如：價格、設施？\n',
                          style: TextStyle(
                              fontSize: 16,
                              color: q8 ? Colors.blue : Colors.black),
                        ),
                      ),
                      q8
                          ? Column(
                              children: <Widget>[
                                Text(
                                  '''可以，可至房屋資訊中的「未出租」中，長按需修改的房源，選擇需修改的項目進行資訊修改。若該房源已有房客簽約，將暫時無法進行修改。''',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  //分享
  void shareIt(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('分享'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text('分享至ＬＩＮＥ'),
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text('分享至ＦＢ'),
                        color: Colors.blueAccent,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text('分享至ＩＧ'),
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                )),
              );
            }),
          );
        });
  }

  //關於
  void aboutUs(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('關於我們'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: SingleChildScrollView(
                  child: Text('''公司簡介 Company
圖文編輯器，內容可自行編輯-我們是一間深根於在地的企業，秉持著專業技術、服務熱誠與優質開發為原則，用心為您做最好的服務。我們希望帶給客戶誠實可靠，工作認真有效率並負責的企業形象，提供最好的產品與專業的服務品質。
 
我們致力於推出最專業的產品服務，並投注心力在開發上，以達到企業與客戶彼此都有最好的感受與成效，這是我們所重視的專業。用心的服務，負責任的態度，是我們的宗旨。我們的產品或服務是您可以放心的項目，使我們成為您可以信賴的商業夥伴。我們重視誠信，言出必行。
合作雙方互惠是我們努力發展的基礎，期待與貴公司有長久互相信賴的合作關係。

選擇我們，是您明智的選擇。999999
'''),
                ),
              );
            }),
          );
        });
  }
}
