// import 'package:b2b_freshmore/global/color_constant.dart';
// import 'package:b2b_freshmore/global/custom_text_field.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';

// class ShiftDropDown extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final void Function(Users?)? callBack;
//   final String? Function(String?)? validator;

//   const ShiftDropDown({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.callBack,
//     this.validator,
//   });

//   @override
//   State<ShiftDropDown> createState() => _ShiftDropDownState();
// }

// class _ShiftDropDownState extends State<ShiftDropDown> {
//   final GlobalKey<DropdownButton2State> dropdownKey =
//       GlobalKey<DropdownButton2State>();

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: BlocBuilder<LevelBloc, ApiState>(
//         builder: (context, state) {
//           List<Users> users = [];
//           if (state is ApiSuccess<LevelModel>) {
//             final rawUsers = state.data.data!.users ?? [];

//             final seenLevels = <String>{};
//             users = rawUsers.where((user) {
//               if (user.level == null) return false;
//               return seenLevels.add(user.level!);
//             }).toList();
//           }
//           return DropdownButton2<Users>(
//             key: dropdownKey,
//             isExpanded: true,
//             customButton: AbsorbPointer(
//               child: CustomTextFormField(
//                 textEditingController: widget.controller,
//                 readOnly: true,
//                 suffixIcon: IconButton(
//                   onPressed: () {
//                     dropdownKey.currentState?.callTap();
//                   },
//                   icon: Icon(
//                     Icons.keyboard_arrow_down,
//                     color: ColorConstant.primaryMainColor,
//                   ),
//                 ),
//                 hintText: widget.hintText,
//                 validator: widget.validator,
//               ),
//             ),
//             items: users.map((shift) {
//               return DropdownMenuItem<Users>(
//                 value: shift,
//                 child: Text(
//                   "Level ${shift.level ?? ""}",
//                   style: const TextStyle(color: Colors.black),
//                 ),
//               );
//             }).toList(),
//             onChanged: (Users? value) {
//               if (value != null) {
//                 widget.controller.text = value.level ?? "";
//                 widget.callBack?.call(value);
//               }
//             },
//             dropdownStyleData: DropdownStyleData(
//               maxHeight: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class AddressDropDown extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final void Function(AddressData?)? callBack;
//   final String? Function(String?)? validator;

//   const AddressDropDown({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.callBack,
//     this.validator,
//   });

//   @override
//   State<AddressDropDown> createState() => _AddressDropDownState();
// }

// class _AddressDropDownState extends State<AddressDropDown> {
//   final GlobalKey<DropdownButton2State> dropdownKey =
//       GlobalKey<DropdownButton2State>();

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: BlocBuilder<AddressBloc, ApiState>(
//         builder: (context, state) {
//           List<AddressData> addList = [];
//           if (state is ApiSuccess<AddressModel>) {
//             final rawUsers = state.data.data ?? [];
//             final seenLevels = <String>{};
//             addList = rawUsers.where((user) {
//               return seenLevels.add(user.name ?? "");
//             }).toList();
//           }
//           return DropdownButton2<AddressData>(
//             key: dropdownKey,
//             isExpanded: true,
//             customButton: AbsorbPointer(
//               child: CustomTextFormField(
//                 textEditingController: widget.controller,
//                 readOnly: true,
//                 suffixIcon: IconButton(
//                   onPressed: () {
//                     dropdownKey.currentState?.callTap();
//                   },
//                   icon: Icon(
//                     Icons.keyboard_arrow_down,
//                     color: ColorConstant.primaryMainColor,
//                   ),
//                 ),
//                 hintText: widget.hintText,
//                 validator: widget.validator,
//               ),
//             ),
//             items: addList.map((shift) {
//               return DropdownMenuItem<AddressData>(
//                 value: shift,
//                 child: Text(
//                   shift.name ?? "",
//                   style: const TextStyle(color: Colors.black),
//                 ),
//               );
//             }).toList(),
//             onChanged: (AddressData? value) {
//               if (value != null) {
//                 widget.controller.text = value.name ?? "";
//                 widget.callBack?.call(value);
//               }
//             },
//             dropdownStyleData: DropdownStyleData(
//               maxHeight: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class WalletDropDown extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final void Function(WalletPaymentDataModel?)? callBack;
//   final String? Function(String?)? validator;

//   const WalletDropDown({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.callBack,
//     this.validator,
//   });

//   @override
//   State<WalletDropDown> createState() => _WalletDropDownState();
// }

// class _WalletDropDownState extends State<WalletDropDown> {
//   final GlobalKey<DropdownButton2State> dropdownKey =
//       GlobalKey<DropdownButton2State>();

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: BlocBuilder<WalletPaymentBloc, ApiState>(
//         builder: (context, state) {
//           List<WalletPaymentDataModel> addList = [];
//           if (state is ApiSuccess<WalletPaymentModel>) {
//             final rawUsers = state.data.data ?? [];
//             final seenLevels = <String>{};
//             addList = rawUsers.where((user) {
//               return seenLevels.add(user.name ?? "");
//             }).toList();
//           }

//           return DropdownButton2<WalletPaymentDataModel>(
//             key: dropdownKey,
//             isExpanded: true,
//             customButton: AbsorbPointer(
//               child: CustomTextFormField(
//                 textEditingController: widget.controller,
//                 readOnly: true,
//                 suffixIcon: IconButton(
//                   onPressed: () {
//                     dropdownKey.currentState?.callTap();
//                   },
//                   icon: Icon(
//                     Icons.keyboard_arrow_down,
//                     color: ColorConstant.primaryMainColor,
//                   ),
//                 ),
//                 hintText: widget.hintText,
//                 validator: widget.validator,
//               ),
//             ),
//             items: addList.map((shift) {
//               return DropdownMenuItem<WalletPaymentDataModel>(
//                 value: shift,
//                 child: Text(
//                   shift.name ?? "",
//                   style: const TextStyle(color: Colors.black),
//                 ),
//               );
//             }).toList(),
//             onChanged: (WalletPaymentDataModel? value) {
//               if (value != null) {
//                 widget.controller.text = value.name ?? "";
//                 widget.callBack?.call(value);
//               }
//             },
//             dropdownStyleData: DropdownStyleData(
//               maxHeight: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class AmountDropDown extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final void Function(String?)? callBack;
//   final String? Function(String?)? validator;

//   const AmountDropDown({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.callBack,
//     this.validator,
//   });

//   @override
//   State<AmountDropDown> createState() => _AmountDropDownState();
// }

// class _AmountDropDownState extends State<AmountDropDown> {
//   final GlobalKey<DropdownButton2State> dropdownKey =
//       GlobalKey<DropdownButton2State>();

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: BlocBuilder<AmountBloc, ApiState>(
//         builder: (context, state) {
//           final seenLevels = <String>{};
//           String currency = "MMK";
//           if (state is ApiSuccess<AmountModel>) {
//             final rawUsers = state.data.data ?? [];

//             final formatter = NumberFormat("#,###");

//             rawUsers.where((user) {
//               currency = user.currency ?? "MMK";
//               final amountValue = double.tryParse(user.amount ?? "0") ?? 0;

//               final formattedAmount = formatter.format(amountValue);

//               return seenLevels.add(formattedAmount);
//             }).toList();
//           }
//           seenLevels.add("Other");
//           return DropdownButton2<String>(
//             key: dropdownKey,
//             isExpanded: true,
//             customButton: AbsorbPointer(
//               child: CustomTextFormField(
//                 textEditingController: widget.controller,
//                 readOnly: true,
//                 suffixIcon: IconButton(
//                   onPressed: () {
//                     dropdownKey.currentState?.callTap();
//                   },
//                   icon: Icon(
//                     Icons.keyboard_arrow_down,
//                     color: ColorConstant.primaryMainColor,
//                   ),
//                 ),
//                 hintText: widget.hintText,
//                 validator: widget.validator,
//               ),
//             ),
//             items: seenLevels.map((shift) {
//               return DropdownMenuItem<String>(
//                 value: shift,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "$shift ${shift != "Other" ? currency : ""}",
//                       style: TextStyle(
//                         color: widget.controller.text == shift
//                             ? ColorConstant.primaryMainColor
//                             : Colors.black,
//                       ),
//                     ),
//                     widget.controller.text == shift
//                         ? Icon(
//                             LucideIcons.check,
//                             color: ColorConstant.primaryMainColor,
//                             size: 20,
//                           )
//                         : SizedBox.shrink(),
//                   ],
//                 ),
//               );
//             }).toList(),
//             onChanged: (String? value) {
//               if (value != null) {
//                 widget.controller.text = value;
//                 widget.callBack?.call(value);
//               }
//             },
//             dropdownStyleData: DropdownStyleData(
//               maxHeight: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
