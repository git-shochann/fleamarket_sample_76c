$(document).on('turbolinks:load', function () {
  $(function () {
    var dataBox = new DataTransfer();
    var file_field = document.querySelector('input[type=file]')
    $('#img-file').change(function () {
      var files = $('input[type="file"]').prop('files')[0];
      $.each(this.files, function (i, file) {
        var fileReader = new FileReader();

        dataBox.items.add(file)
        file_field.files = dataBox.files

        var num = $('.item-image').length + 1 + i
        fileReader.readAsDataURL(file);
        if (num == 5) {
          $('#image').css('display', 'none')
        }
        fileReader.onloadend = function () {
          var src = fileReader.result
          var html = `<div class='item-image' data-image="${file.name}">
                      <div class=' item-image__content'>
                        <div class='item-image__content--icon'>
                          <img src=${src} width="114" height="80" >
                        </div>
                      </div>
                      <div class='item-image__operetion'>
                        <div class='item-image__operetion--delete'>削除</div>
                      </div>
                    </div>`

          $('#image').before(html);
        };

        $('#image').attr('class', `input-area-${num}`)
      });
    });

    // チェックボックスを非表示にするcss（現時点では動作確認用に表示させている。完成したら非表示にする事）
    // $('.hidden-destroy').hide();

    $(document).on("click", '.item-image__operetion--delete', function () {
      var target_image = $(this).parent().parent()
      var target_name = $(target_image).data('image')

      // ↓追加
      const hiddenCheck = $(`input[data-image="${target_name}"].hidden-destroy`);
      // もしチェックボックスが存在すればチェックを入れる
      if (hiddenCheck) {
        hiddenCheck.prop('checked', true)
      };
      // ↑追加
      // 「削除」をクリックするとチェックボックスにチェックが入るが、submitと結び付けられていないためDBから削除が出来ない

      // file_field.files：挿入された画像ファイルの配列
      if (file_field.files.length == 1) {
        $('input[type=file]').val(null)
        dataBox.clearData();
        console.log(dataBox)
      } else {
        $.each(file_field.files, function (i, input) {
          if (input.name == target_name) {
            dataBox.items.remove(i)
          }
        })
        file_field.files = dataBox.files
      }
      target_image.remove()
      var num = $('.item-image').length
      $('#image').show()
      $('#image').attr('class', `input-area-${num}`)
    })
  });
});
