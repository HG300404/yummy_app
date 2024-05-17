import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/ui/screens/signin_page.dart';

import '../widget/common_widget/category_cell.dart';
import '../widget/common_widget/most_popular_cell.dart';
import '../widget/common_widget/popular_resutaurant_row.dart';
import '../widget/common_widget/recent_item_row.dart';
import '../widget/common_widget/round_textfield.dart';
import '../widget/common_widget/view_all_title_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtSearch = TextEditingController();

  List catArr = [
    {"image": "assets/images/cat_offer.png", "name": "Fast Food"},
    {"image": "assets/images/cat_sri.png", "name": "Cơm nhà"},
    {"image": "assets/images/cat_3.png", "name": "Trái cây"},
    {"image": "assets/images/cat_4.png", "name": "Đồ ăn Ấn"},
  ];

  List popArr = [
    {
      "image": "assets/images/res_1.png",
      "name": "Pizza",
      "rate": "4.9",
      "rating": "124",
      "type": "Món chính",
      "food_type": "Đồ Ăn Nhanh"
    },
    {
      "image": "assets/images/res_2.png",
      "name": "Cafe và Bánh ngọt",
      "rate": "4.5",
      "rating": "45",
      "type": "Món phụ",
      "food_type": "Tráng miệng"
    },
    {
      "image": "assets/images/res_3.png",
      "name": "Bakery PonPas",
      "rate": "4.8",
      "rating": "324",
      "type": "Món phụ",
      "food_type": "Tráng miệng"
    },
  ];

  List mostPopArr = [
    {
      "image": "assets/images/m_res_1.png",
      "name": "Pizza 4P",
      "rate": "4.9",
      "rating": "156",
      "type": "Món chính",
      "food_type": "Fast Food"
    },
    {
      "image": "assets/images/m_res_2.png",
      "name": "Café & Chill",
      "rate": "4.4",
      "rating": "156",
      "type": "Đồ uống & Tráng Miệng",
      "food_type": "Đồ ngọt"
    },
  ];

  List recentArr = [
    {
      "image": "assets/images/item_1.png",
      "name": "Pizza Company",
      "rate": "4.7",
      "rating": "174",
      "type": "Món chính",
      "food_type": "Fast Food"
    },
    {
      "image": "assets/images/item_2.png",
      "name": "Coffee",
      "rate": "4.9",
      "rating": "124",
      "type": "Đồ uống",
      "food_type": "cafe"
    },
    {
      "image": "assets/images/item_3.png",
      "name": "Pizza Rush ",
      "rate": "4.9",
      "rating": "124",
      "type": "Món chính",
      "food_type": "Fast Food"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chào buổi sáng",
                      style: TextStyle(
                          color: Constants.lightTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()));
                      },
                      icon: Image.asset(
                        "assets/images/shopping-cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivering to",
                      style:
                      TextStyle(color: Constants.textColor, fontSize: 11),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Current Location",
                          style: TextStyle(
                              color: Constants.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Image.asset(
                          "assets/images/dropdown.png",
                          width: 12,
                          height: 12,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: "Search Food",
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/images/search.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: catArr.length,
                  itemBuilder: ((context, index) {
                    var cObj = catArr[index] as Map? ?? {};
                    return CategoryCell(
                      cObj: cObj,
                      onTap: () {},
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Popular Restaurants",
                  onView: () {},
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: popArr.length,
                itemBuilder: ((context, index) {
                  var pObj = popArr[index] as Map? ?? {};
                  return PopularRestaurantRow(
                    pObj: pObj,
                    onTap: () {},
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Most Popular",
                  onView: () {},
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: mostPopArr.length,
                  itemBuilder: ((context, index) {
                    var mObj = mostPopArr[index] as Map? ?? {};
                    return MostPopularCell(
                      mObj: mObj,
                      onTap: () {},
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Recent Items",
                  onView: () {},
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: recentArr.length,
                itemBuilder: ((context, index) {
                  var rObj = recentArr[index] as Map? ?? {};
                  return RecentItemRow(
                    rObj: rObj,
                    onTap: () {},
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
