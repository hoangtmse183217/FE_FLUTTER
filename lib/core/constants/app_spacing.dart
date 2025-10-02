// lib/core/constants/app_spacing.dart
import 'package:flutter/widgets.dart';

// =================================================================
// HẰNG SỐ KÍCH THƯỚC CƠ BẢN (dùng cho padding, margin, radius...)
// =================================================================
const double kSpacingXXS = 2.0;  // Rất nhỏ
const double kSpacingXS = 4.0;   // Rất nhỏ
const double kSpacingS = 8.0;    // Nhỏ
const double kSpacingM = 16.0;   // Vừa (mặc định)
const double kSpacingL = 24.0;   // Lớn
const double kSpacingXL = 32.0;  // Rất lớn
const double kSpacingXXL = 48.0; // Rất lớn

// =================================================================
// WIDGET KHOẢNG CÁCH DỌC (để chèn vào giữa các widget trong Column)
// =================================================================
const vSpaceXXS = SizedBox(height: kSpacingXXS);
const vSpaceXS = SizedBox(height: kSpacingXS);
const vSpaceS = SizedBox(height: kSpacingS);
const vSpaceM = SizedBox(height: kSpacingM);
const vSpaceL = SizedBox(height: kSpacingL);
const vSpaceXL = SizedBox(height: kSpacingXL);
const vSpaceXXL = SizedBox(height: kSpacingXXL);

// =================================================================
// WIDGET KHOẢNG CÁCH NGANG (để chèn vào giữa các widget trong Row)
// =================================================================
const hSpaceXXS = SizedBox(width: kSpacingXXS);
const hSpaceXS = SizedBox(width: kSpacingXS);
const hSpaceS = SizedBox(width: kSpacingS);
const hSpaceM = SizedBox(width: kSpacingM);
const hSpaceL = SizedBox(width: kSpacingL);
const hSpaceXL = SizedBox(width: kSpacingXL);
const hSpaceXXL = SizedBox(width: kSpacingXXL);