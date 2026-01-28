import 'package:flutter/material.dart';
import 'package:kids_space_admin/model/company.dart';

typedef CompanyTapCallback = void Function(Company company);

class CompanyList extends StatelessWidget {
  final List<Company> companies;
  final CompanyTapCallback onTap;

  const CompanyList({
    super.key,
    required this.companies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(company.fantasyName ?? ''),
            leading: SizedBox(
              width: 56,
              child: Center(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  child: Text(company.fantasyName?.isNotEmpty == true ? company.fantasyName![0] : '?'),
                ),
              ),
            ),
            onTap: () => onTap(company),
          ),
        );
      },
    );
  }
}
