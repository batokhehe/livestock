import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';
import '../../features/attendance/providers/attendance_provider.dart';
import '../../features/attendance/data/model/employee_model.dart';
import '../data/model/base_response.dart';
import '../../app/providers.dart';

final paginatedEmployeeProvider = AsyncNotifierProvider.autoDispose<
    EmployeePaginatedNotifier, BaseResponse<Employee>>(
  EmployeePaginatedNotifier.new,
);

class EmployeePaginatedNotifier
    extends AutoDisposeAsyncNotifier<BaseResponse<Employee>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<BaseResponse<Employee>> build() async {
    _page = 1;
    final keyword = ref.watch(employeeSearchProvider);
    final api = ref.read(attendanceApiProvider);
    final farmLocation = ref.watch(attendanceFormFarmLocationProvider) ??
        ref.watch(selectedFarmLocationProvider);

    return await api.getEmployees(
      farmLocationId: farmLocation?.id,
      search: keyword.isNotEmpty ? keyword : null,
      page: _page,
      perPage: 10,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore) return;

    final total = current.total ?? 0;
    if (current.data.length >= total) return;

    _loadingMore = true;
    _page++;

    final keyword = ref.read(employeeSearchProvider);
    final api = ref.read(attendanceApiProvider);
    final farmLocation = ref.read(attendanceFormFarmLocationProvider) ??
        ref.read(selectedFarmLocationProvider);

    final result = await api.getEmployees(
      farmLocationId: farmLocation?.id,
      search: keyword.isNotEmpty ? keyword : null,
      page: _page,
      perPage: 10,
    );

    state = AsyncData(
      BaseResponse(
        status: result.status,
        message: result.message,
        total: result.total,
        data: [...current.data, ...result.data],
      ),
    );

    _loadingMore = false;
  }
}

class EmployeeBottomSheet extends ConsumerStatefulWidget {
  final int? initialSelectedId;
  final String title;
  final String description;

  const EmployeeBottomSheet({
    super.key,
    this.initialSelectedId,
    this.title = "Pilih Karyawan",
    this.description = "Silakan pilih salah satu karyawan.",
  });

  @override
  ConsumerState<EmployeeBottomSheet> createState() => _EmployeeBottomSheetState();
}

class _EmployeeBottomSheetState extends ConsumerState<EmployeeBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  int? _currentSelectedId;
  Timer? _debounce;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentSelectedId = widget.initialSelectedId;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedEmployeeProvider.notifier).loadMore();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeeSearchProvider.notifier).state = '';
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(paginatedEmployeeProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: AppTypography.largeBoldBlack),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.description, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 20),

          TextField(
            controller: _searchCtrl,
            onChanged: (val) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                ref.read(employeeSearchProvider.notifier).state = val;
              });
            },
            decoration: InputDecoration(
              hintText: "Cari karyawan...",
              hintStyle: AppTypography.smallNormalGrey,
              prefixIcon: const Icon(Icons.search, color: AppColors.grey),
              filled: true,
              fillColor: AppColors.greyBg,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: asyncData.when(
              data: (res) {
                final items = res.data;
                final total = res.total ?? 0;
                final hasMore = items.length < total;

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Karyawan tidak ditemukan",
                      style: AppTypography.smallNormalGrey,
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = items[index];
                    final isSelected = _currentSelectedId == item.id;

                    return _buildItem(
                      title: "${item.name} • ${item.phone}",
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _currentSelectedId = item.id;
                        });
                        Navigator.pop(context, item);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  "Gagal memuat data karyawan\n$e",
                  textAlign: TextAlign.center,
                  style: AppTypography.smallNormalGrey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: isSelected
                  ? AppTypography.smallBoldBlack
                  : AppTypography.smallNormalBlack,
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
