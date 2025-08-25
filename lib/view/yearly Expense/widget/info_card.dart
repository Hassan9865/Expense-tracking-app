// import 'package:daily_expense/view/yearly%20Expense/widget/card.dart';
// import 'package:daily_expense/view/yearly%20Expense/yearly_expense_viewModel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:stacked/stacked.dart';

// class InfoCard extends ViewModelWidget<YearlyExpenseViewmodel> {
//   const InfoCard({super.key});

//   @override
//   Widget build(BuildContext context, YearlyExpenseViewmodel viewModel) {
//     return Column(
//       children: [
//         // Information Card
//         Card(
//           elevation: 2,
//           color: Colors.blue.shade50,
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Icon(Icons.info_outline, color: Colors.blue.shade700),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Your monthly expenses will be added here once the month ends.",
//                     style: TextStyle(
//                       color: Colors.blue.shade800,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Current Month Data Card
//         Card(
//           elevation: 2,
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             children: [
//               ListTile(
//                 tileColor: Colors.green.shade50,
//                 title: Text(
//                   "August 2025",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Row(
//                   children: [
//                     // Total Income Card
//                     Expanded(
//                         child: YealryCard(
//                       amount: "50000",
//                       txt: 'Total Income',
//                       color: Colors.red.shade600,
//                     )),

//                     Expanded(
//                         child: YealryCard(
//                             amount: "50000",
//                             txt: 'Total Expense',
//                             color: Colors.red.shade600)),

//                     Expanded(
//                         child: YealryCard(
//                       amount: "50000",
//                       txt: 'Total Saving',
//                       color: Colors.blue,
//                     )),
//                   ],
//                 ),
//                 leading: Column(
//                   children: [
//                     Icon(Icons.calendar_today, color: Colors.green),
//                     IconButton(
//                         onPressed: () {},
//                         icon: Icon(Icons.arrow_downward_outlined))
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:daily_expense/view/yearly%20Expense/widget/infoItem.dart';
import 'package:daily_expense/view/yearly%20Expense/yearly_expense_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';

class InfoCard extends ViewModelWidget<YearlyExpenseViewmodel> {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context, YearlyExpenseViewmodel viewModel) {
    return Column(
      children: [
        // Information Card (initially hidden)
        if (viewModel.isInfoExpanded)
          Card(
            elevation: 2,
            color: Colors.blue.shade50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Your monthly expenses will be added here once the month ends.",
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Current Month Data Card (Compact version)
        Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                // Calendar icon with arrow button

                IconButton(
                  onPressed: () {
                    viewModel.toggleInfoExpanded();
                  },
                  icon: Icon(
                    viewModel.isInfoExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: MediaQuery.of(context).size.width * 0.08,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),

                const SizedBox(width: 8),

                // Month and year
                Expanded(
                  flex: 1,
                  child: Text(
                    "Aug 2025",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),

                // Compact financial info
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InfoItem(
                        value: "50,000",
                        label: "Income",
                        color: Colors.green,
                      ),
                      InfoItem(
                        value: "30,000",
                        label: "Expense",
                        color: Colors.red,
                      ),
                      InfoItem(
                        value: "20,000",
                        label: "Saving",
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Helper widget for compact info items
