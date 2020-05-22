$(document).on('turbolinks:load', function() {

  // セレクトボックスにて選択されたgroup.codeに紐づくgroup.name表示用
  $('#select-group-code').on('change', function() {
    // 選択されたoptionタグのvalue値(group.id)を取得
    var groupCode = $('#select-group-code option:selected').val();
    // group.codeに紐づいたgroup.nameを表示するinputタグを取得
    var $groupName = $('#select-group-name');
    if (groupCode) {
      // gon.groups = { id => name, id => name, ... }
      $groupName.val(gon.groups[groupCode]);
    } else {
      $groupName.val(null);
    };
  });


  // Category選択後のイベント
  $('#select-category').on('change', function() {
    var categoryId = $('#select-category option:selected').val();
    var $subCategory =$('#select-sub-category')
    var $otherCategory = $('#text-other-category');
    var $badgeRequired = $('#badge-required');

    // SubCategoryのoptionタグを全て削除
    $subCategory.children().remove();
    $subCategory.append($('<option>').html("---").val(null));

    // 選択されたcategory_idと一致するsub_categoryをoptionタグに追加
    // gon.subCategoies = [[id, name, cateogry_id], [id, name, cateogry_id], ...]
    $.each(gon.subCategories, function(index, value) {
      if (value[2] == categoryId) $subCategory.append($('<option>').html(value[1]).val(value[0]));
    });

    // その他入力欄を初期化
    if (categoryId) $subCategory.append($('<option>').html("その他").val(null));
    $otherCategory.val(null);
    $otherCategory.attr('disabled', 'disabled');
    $badgeRequired.addClass('d-none');
  });


  // Category選択後のイベント
  $('#select-sub-category').on('change', function() {
    var $otherCategory = $('#text-other-category');
    var $badgeRequired = $('#badge-required');

    // SubCategoryにて「その他」が選択されたかどうかで、編集の可否の切替を行う
    if ($('#select-sub-category option:selected').text() == 'その他' ) {
      $otherCategory.removeAttr('disabled');
      $badgeRequired.removeClass('d-none');

      // 「その他」選択時、Categoryに紐づくOtherCategoryのoptionタグを生成
      var categoryId = $('#select-category option:selected').val();
      var $otherCategoryDataList = $('#other-category-list')
      $.each(gon.otherCategories, function(index, value) {
        if (value[1] == categoryId) $otherCategoryDataList.append($('<option>').val(value[0]));
      });

    } else {

      $otherCategory.val(null);
      $otherCategory.attr('disabled', 'disabled');
      $badgeRequired.addClass('d-none');

    };
  });


  // Place選択後のイベント
  $('#select-place-id').on('change', function() {
    var place_id = $('#select-place-id option:selected').val();
    var $building = $('#select-place-building');
    var $room_num = $('#select-place-room');
    var $name = $('#select-place-name');

    // if (place_id) (buiding, room_num, name) = ( null, null, null );
    if (place_id) {
      // gon.placeMaster = { id => [buiding, room_num, name], id => [buiding, room_num, name], ...}
      $building.val(gon.placeMaster[place_id][0]);
      $room_num.val(gon.placeMaster[place_id][1]);
      $name.val(gon.placeMaster[place_id][2]);
    } else {
      $building.val(null);
      $room_num.val(null);
      $name.val(null);
    };
  });

})