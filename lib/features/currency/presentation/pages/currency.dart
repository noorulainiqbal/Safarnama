import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/assets.dart';
import '../provider/currency_provider.dart';
import '../widget/currency_dropdown.dart';
import '../../domain/entities/currency_entity.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CurrencyProvider>(context, listen: false);
      provider.initialize();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                SizedBox(height: context.h(30)),
                if (provider.isLoading)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  )
                else if (provider.error != null)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(context.w(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: context.sp(48),
                              color: Colors.red,
                            ),
                            SizedBox(height: context.h(16)),
                            Text(
                              provider.error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: context.sp(16),
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: context.h(16)),
                            ElevatedButton(
                              onPressed: provider.initialize,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryOrange,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.retry,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: context.sp(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.currencyConverterTitle,
                          ),
                          SizedBox(height: context.h(20)),
                          _buildConverterCard(context, provider),
                          SizedBox(height: context.h(32)),
                          _buildSectionTitle(
                            context,
                            AppLocalizations.of(context)!.exchangeRateTitle,
                          ),
                          SizedBox(height: context.h(16)),
                          if (provider.exchangeRate != null)
                            _buildExchangeRateCard(context, provider),
                          SizedBox(height: context.h(32)),
                          _buildSectionTitle(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.popularCurrenciesTitle,
                          ),
                          SizedBox(height: context.h(16)),
                          _buildPopularCurrenciesList(context, provider),
                          SizedBox(height: context.h(40)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.h(56),
        left: context.w(20),
        right: context.w(20),
      ),
      child: SizedBox(
        width: context.w(335),
        height: context.h(44),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _appBarIcon(context, MyAssets.backicon),
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.currencyConverterTitle,
                  style: TextStyle(
                    fontFamily: "SF UI Display",
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(18),
                    height: 22 / 18,
                    color: const Color(0xFF1B1E28),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.w(44)),
          ],
        ),
      ),
    );
  }

  Widget _appBarIcon(BuildContext context, String icon) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: context.w(44),
            height: context.h(44),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image.asset(
                icon,
                width: context.w(24),
                height: context.h(24),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'SF UI Display',
        fontWeight: FontWeight.w600,
        fontSize: context.sp(20),
        height: 28 / 20,
        color: const Color(0xFF1B1E28),
      ),
    );
  }

  Widget _buildConverterCard(BuildContext context, CurrencyProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x24B4BCC9),
            offset: const Offset(0, 6),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCurrencyInputField(
            context,
            label: AppLocalizations.of(context)!.fromLabel,
            provider: provider,
            isFrom: true,
          ),
          SizedBox(height: context.h(20)),
          _buildSwapButton(context, provider),
          SizedBox(height: context.h(20)),
          _buildCurrencyInputField(
            context,
            label: AppLocalizations.of(context)!.toLabel,
            provider: provider,
            isFrom: false,
          ),
          SizedBox(height: context.h(24)),
        ],
      ),
    );
  }

  Widget _buildCurrencyInputField(
    BuildContext context, {
    required String label,
    required CurrencyProvider provider,
    required bool isFrom,
  }) {
    // FIX: Use toAmount directly instead of totalAmount
    final amount = isFrom
        ? provider.fromAmount
        : (provider.conversionResult?.toAmount ?? 0);
    final formattedAmount = provider.formatAmount(amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'SF UI Display',
            fontWeight: FontWeight.w600,
            fontSize: context.sp(13),
            letterSpacing: 0.3,
            color: const Color(0xFF7D848D),
          ),
        ),
        SizedBox(height: context.h(12)),
        Container(
          padding: EdgeInsets.all(context.w(16)),
          decoration: BoxDecoration(
            color: !isFrom ? const Color(0xFFF7F7F9) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8ECF4), width: 1.5),
          ),
          child: Row(
            children: [
              CurrencyDropdown(isFromCurrency: isFrom),
              SizedBox(width: context.w(12)),
              Expanded(
                child: isFrom
                    ? TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(22),
                          color: const Color(0xFF1B1E28),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          provider.updateFromAmount(value);
                        },
                      )
                    : Text(
                        formattedAmount,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(22),
                          color: const Color(0xFFFF7029),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwapButton(BuildContext context, CurrencyProvider provider) {
    return GestureDetector(
      onTap: provider.swapCurrencies,
      child: Container(
        width: context.w(44),
        height: context.h(44),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7029),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.swap_vert, size: context.sp(24), color: Colors.white),
      ),
    );
  }

  /*Widget _buildConvertButton(BuildContext context, CurrencyProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: context.h(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7029),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: provider.isConverting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Convert',
                style: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w600,
                  fontSize: context.sp(16),
                  color: Colors.white,
                ),
              ),
      ),
    );
  }*/

  Widget _buildExchangeRateCard(
    BuildContext context,
    CurrencyProvider provider,
  ) {
    final exchangeRate = provider.exchangeRate;
    final change = exchangeRate?.change ?? 0;
    final changePercentage = exchangeRate?.changePercentage ?? 0;
    final isPositive = change >= 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFFF7029), const Color(0xFFFF8F4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40FF7029),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 ${provider.fromCurrency?.code ?? ''}',
                style: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w600,
                  fontSize: context.sp(18),
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(12),
                  vertical: context.h(6),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AppLocalizations.of(context)!.liveRate,
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w500,
                    fontSize: context.sp(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(8)),
          Text(
            '= ${exchangeRate?.rate.toStringAsFixed(4)} ${provider.toCurrency?.code ?? ''}',
            style: TextStyle(
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w600,
              fontSize: context.sp(28),
              color: Colors.white,
            ),
          ),
          SizedBox(height: context.h(12)),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: context.sp(14),
                color: Colors.white,
              ),
              SizedBox(width: context.w(4)),
              Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(4)} '
                '(${isPositive ? '+' : ''}${changePercentage.toStringAsFixed(2)}%) ${AppLocalizations.of(context)!.today}',
                style: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w400,
                  fontSize: context.sp(13),
                  color: Colors.white.withValues(alpha: .9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCurrenciesList(
    BuildContext context,
    CurrencyProvider provider,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x24B4BCC9),
            offset: const Offset(0, 6),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < provider.popularCurrencies.length; i++)
            Column(
              children: [
                _buildCurrencyListItem(
                  context,
                  currency: provider.popularCurrencies[i],
                  rate:
                      provider.latestRates[provider
                          .popularCurrencies[i]
                          .code] ??
                      0,
                ),
                if (i < provider.popularCurrencies.length - 1)
                  _buildDivider(context),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCurrencyListItem(
    BuildContext context, {
    required CurrencyEntity currency,
    required double rate,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(14),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(40),
            height: context.h(40),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                currency.flagEmoji,
                style: TextStyle(fontSize: context.sp(24)),
              ),
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currency.code,
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(16),
                    letterSpacing: 0.5,
                    color: const Color(0xFF1B1E28),
                  ),
                ),
                SizedBox(height: context.h(2)),
                Text(
                  currency.name,
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w400,
                    fontSize: context.sp(13),
                    letterSpacing: 0.3,
                    color: const Color(0xFF7D848D),
                  ),
                ),
              ],
            ),
          ),
          Text(
            rate.toStringAsFixed(4),
            style: TextStyle(
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w600,
              fontSize: context.sp(16),
              color: const Color(0xFFFF7029),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Divider(height: 1, thickness: 1, color: const Color(0xFFF7F7F9)),
    );
  }
}
