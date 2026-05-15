import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/receiving/data/model/receiving_detail_model.dart';
import 'package:livestock/features/receiving/data/model/receiving_list_model.dart';
import 'package:livestock/features/receiving/data/model/receiving_po_model.dart';

import '../../core/data/model/farm_location_model.dart';
import '../../core/network/dio_client.dart';
import 'data/api/receiving_api.dart';
import 'data/model/receiving_item_model.dart';

enum ReceivingTab { animal, feed, equipment }

extension ReceivingTabX on ReceivingTab {
  String get apiValue {
    switch (this) {
      case ReceivingTab.animal:
        return 'animal';
      case ReceivingTab.feed:
        return 'feed-medicine';
      case ReceivingTab.equipment:
        return 'equipment-supplies';
    }
  }

  String get label {
    switch (this) {
      case ReceivingTab.animal:
        return 'Hewan';
      case ReceivingTab.feed:
        return 'Pakan & Obat';
      case ReceivingTab.equipment:
        return 'Peralatan';
    }
  }

  String get ext {
    switch (this) {
      case ReceivingTab.animal:
        return 'hewan';
      case ReceivingTab.feed:
        return 'item';
      case ReceivingTab.equipment:
        return 'item';
    }
  }
}

final receivingSearchProvider = StateProvider<String>((ref) => '');
final receivingPoSearchProvider = StateProvider<String>((ref) => '');
final receivingLocationFilterProvider = StateProvider<FarmLocation?>(
  (ref) => null,
);

final receivingTabProvider = StateProvider<ReceivingTab>((ref) {
  return ReceivingTab.animal;
});

final receivingApiProvider = Provider((ref) {
  return ReceivingApi(ref.read(dioProvider));
});

final receivingDateProvider = StateProvider<DateTime?>((ref) => DateTime.now());

final receivingFormProvider = ChangeNotifierProvider<ReceivingProvider>((ref) {
  return ReceivingProvider();
});

class ReceivingProvider extends ChangeNotifier {
  /// ================= ITEMS =================
  List<ReceivingItem> items = [];

  void setItems(List<ReceivingItem> data, {int? animalGroupId}) {
    items = data.map((e) {
      e.animalGroupId = animalGroupId ?? 0;
      return e;
    }).toList();

    notifyListeners();
  }

  void reset() {
    items = [];
    notifyListeners();
  }

  void toggleItem(int id) {
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1) {
      items[index].selected = !items[index].selected;
      notifyListeners();
    }
  }

  void updateCode(int id, String value) {
    final item = items.firstWhere((e) => e.id == id);
    item.itemCode = value;
    notifyListeners();
  }

  void updateNotes(int id, String value) {
    final item = items.firstWhere((e) => e.id == id);
    item.notes = value;
    notifyListeners();
  }

  void updateWeight(int id, String value) {
    final item = items.firstWhere((e) => e.id == id);
    item.receivedWeight = double.tryParse(value);
    notifyListeners();
  }

  // void updateQty(int id, String value) {
  //   final item = items.firstWhere((e) => e.id == id);
  //   item.qty = value;
  //   notifyListeners();
  // }

  void updateProofImage(int id, File? file) {
    final item = items.firstWhere((e) => e.id == id);
    item.proofImage = file;
    notifyListeners();
  }

  List<ReceivingItem> get selectedItems =>
      items.where((e) => e.selected).toList();

  /// ================= PROOF IMAGE =================
  File? proofImage;

  void setProofImage(File file) {
    proofImage = file;
    notifyListeners();
  }

  void clearProofImage() {
    proofImage = null;
    notifyListeners();
  }

  String remarks = '';

  void setRemarks(String value) {
    remarks = value;
    notifyListeners();
  }

  bool get hasProofImage => proofImage != null;

  Future<void> submitReceiving({
    required ReceivingApi api,
    required ReceivingTab type,
    required int farmLocationId,
    required int farmAreaId,
    required DateTime receiveDate,
    required String remarks,
  }) async {
    // if (proofImage == null) {
    //   throw Exception("Proof image is required");
    // }

    final itemsPayload = type == ReceivingTab.animal
        ? selectedItems.map((e) => e.toAnimalJson()).toList()
        : selectedItems.map((e) => e.toItemJson()).toList();

    await api.submitReceiving(
      type: type.apiValue,
      receiveDate: receiveDate,
      farmLocationId: farmLocationId,
      farmAreaId: farmAreaId,
      remarks: remarks,
      items: itemsPayload,
      // proofImage: proofImage!,
    );
  }
}

final receivingDetailProvider = FutureProvider.family<ReceivingDetail, int>((
  ref,
  id,
) async {
  final api = ref.read(receivingApiProvider);
  return api.getReceivingDetail(id);
});
