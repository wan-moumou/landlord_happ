class NewHouse {
  //下拉選單值
  String houseTypeValues = '';
  String roomTypeValues;
  String cityValues = '';
  String houseIsWhoValues = '';
  String genderValues = '';
  String smokeValues = '';
  String partyValues = '';
  String petValues = '';
  //輸入匡值
  String addressValues = ''; //地址
  String floorValues = ''; //樓層
  String allFloorValues = ''; //全部樓層樓層
  String areaValues = ''; //房屋面積
  String bedroomsNumValues = ''; //臥室數量
  String bedNumValues = ''; //床數
  String cashTime = ''; //繳費時間
  String houseMoney = ''; //房租費用
  String waterMoney = ''; //水費
  String deposit = ''; //水費
  String electricityMoney = ''; //電費
  String bathroomType = ''; //衛浴類型
  String haveBalcony = ''; //有無陽台
  String haveKitchen = ''; //有無廚房
  String haveLivingRoom = ''; //有無客廳

  NewHouse(
      {this.addressValues,
      this.cashTime,
      this.houseMoney,
      this.waterMoney,
      this.electricityMoney});
  Map<String, dynamic> data = {
    '縣市': '請選擇',
    '建物型態': '請選擇',
    '房間類型': '請選擇',
    '房源': '請選擇',
    '性別': '請選擇',
    '吸菸': '請選擇',
    '開伙': '請選擇',
    '寵物': '請選擇',
    '衛浴類型': '請選擇',
    '客廳': '請選擇',
    '廚房': '請選擇',
    '陽台': '請選擇',
  };
  List<Map<String, dynamic>> livingRoom = [
    {'客廳': '請選擇'},
    {'客廳': '有'},
    {'客廳': '無'},
  ];
  List<Map<String, dynamic>> kitchen = [
    {'廚房': '請選擇'},
    {'廚房': '有'},
    {'廚房': '無'},
  ];
  List<Map<String, dynamic>> balcony = [
    {'陽台': '請選擇'},
    {'陽台': '有'},
    {'陽台': '無'},
  ];
  List<Map<String, dynamic>> bathroom = [
    {'衛浴類型': '請選擇'},
    {'衛浴類型': '公共'},
    {'衛浴類型': '獨立'},
  ];
  List<Map<String, dynamic>> city = [
    {'縣市': '請選擇'},
    {'縣市': '臺北市'},
    {'縣市': '新北市'},
    {'縣市': '桃園市'},
    {'縣市': '臺中市'},
    {'縣市': '臺南市'},
    {'縣市': '高雄市'},
    {'縣市': '基隆市'},
    {'縣市': '新竹市'},
    {'縣市': '嘉義市'},
    {'縣市': '新竹縣'},
    {'縣市': '苗栗縣'},
    {'縣市': '彰化縣'},
    {'縣市': '南投縣'},
    {'縣市': '雲林縣'},
    {'縣市': '嘉義縣'},
    {'縣市': '屏東縣'},
    {'縣市': '宜蘭縣'},
    {'縣市': '花蓮縣'},
    {'縣市': '臺東縣'},
    {'縣市': '澎湖縣'},
    {'縣市': '金門縣'},
    {'縣市': '連江縣'},
  ];
  List<Map<String, dynamic>> houseType = [
    {'建物型態': '請選擇'},
    {'建物型態': '公寓'},
    {'建物型態': '別墅'},
    {'建物型態': '電梯大樓'},
    {'建物型態': '店面'},
    {'建物型態': '透天厝'},
  ];
  List<Map<String, dynamic>> roomType = [
    {'房間類型': '請選擇'},
    {'房間類型': '雅房'},
    {'房間類型': '分租套房'},
    {'房間類型': '獨立套房'},
    {'房間類型': '整個房源'},
  ];
  List<Map<String, dynamic>> houseIsHwo = [
    {'房源': '請選擇'},
    {'房源': '本人'},
    {'房源': '代租人'},
    {'房源': '轉租人'},
  ];
  List<Map<String, dynamic>> gender = [
    {'性別': '請選擇'},
    {'性別': '男'},
    {'性別': '女'},
    {'性別': '不限'},
  ];
  List<Map<String, dynamic>> smokes = [
    {'吸菸': '請選擇'},
    {'吸菸': '可'},
    {'吸菸': '不可'},
  ];
  List<Map<String, dynamic>> party = [
    {'開伙': '請選擇'},
    {'開伙': '可'},
    {'開伙': '不可'},
  ];
  List<Map<String, dynamic>> pet = [
    {'寵物': '請選擇'},
    {'寵物': '可'},
    {'寵物': '不可'},
  ];
  //繳費方式
  bool waterStoredValue = false;
  bool storedValue = false;
  bool waterFixed = true;
  bool fixed = true;
  //其他費用
  bool managementFee = false;
  bool internetFee = false;
  bool television = false;
  bool gasFee = false;
}

class Furniture {
  //家具設備
  bool tvTable = false;
  bool diningTable = false;
  bool shoeBox = false;
  bool bookBox = false;
  bool wardrobe = false;
  bool sofa = false;
  bool coffeeTable = false;
  bool bedside = false;
  bool gasStove = false;
  bool bookTable = false;
  bool dressingTable = false;
  bool fluidTable = false;
  bool locker = false;
  bool tv = false; //13
  bool wifi = false;
  bool airConditioner = false;
  bool washingMachine = false;
  bool waterHeater = false;
  bool microwaveOven = false;
  bool oven = false;
  bool phone = false;
  bool cookerHood = false;
  bool gas = false;
  bool wiredNetwork = false;
  bool preservation = false;
  bool fingerprintPasswordLock = false;
  bool refrigerator = false;
  bool dishwasher = false;
}
