# RapidOCR4j

B4J wrapper of RapidOCR

You can find the models in the following list:

To use the models in ImageTrans, you need to put the dict file and the model file under the `rapidocr` folder.

```
  PP-OCRv5:
    det:
      ch_PP-OCRv5_mobile_det.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/det/ch_PP-OCRv5_mobile_det.onnx
        SHA256: 4d97c44a20d30a81aad087d6a396b08f786c4635742afc391f6621f5c6ae78ae
      ch_PP-OCRv5_server_det.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/det/ch_PP-OCRv5_server_det.onnx
        SHA256: 0f8846b1d4bba223a2a2f9d9b44022fbc22cc019051a602b41a7fda9667e4cad
      multi_PP-OCRv3_det_infer.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv4/det/Multilingual_PP-OCRv3_det_infer.onnx
        SHA256: 5475c6c7f4d84a6c4f32241b487435d59f126a40c023387af99732258844cdc3
    rec:
      ch_PP-OCRv5_rec_mobile_infer:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/rec/ch_PP-OCRv5_rec_mobile_infer.onnx
        dict_url: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/paddle/PP-OCRv5/rec/ch_PP-OCRv5_rec_mobile_infer/ppocrv5_dict.txt
        SHA256: 5825fc7ebf84ae7a412be049820b4d86d77620f204a041697b0494669b1742c5
      ch_PP-OCRv5_rec_server_infer.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/rec/ch_PP-OCRv5_rec_server_infer.onnx
        dict_url: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/paddle/PP-OCRv5/rec/ch_PP-OCRv5_rec_server_infer/ppocrv5_dict.txt
        SHA256: e09385400eaaaef34ceff54aeb7c4f0f1fe014c27fa8b9905d4709b65746562a
      korean_PP-OCRv5_rec_mobile_infer.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/rec/korean_PP-OCRv5_rec_mobile_infer.onnx
        dict_url: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/paddle/PP-OCRv5/rec/korean_PP-OCRv5_rec_mobile_infer/ppocrv5_korean_dict.txt
        SHA256: cd6e2ea50f6943ca7271eb8c56a877a5a90720b7047fe9c41a2e541a25773c9b
      latin_PP-OCRv5_rec_mobile_infer.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/rec/latin_PP-OCRv5_rec_mobile_infer.onnx
        dict_url: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/paddle/PP-OCRv5/rec/latin_PP-OCRv5_rec_mobile_infer/ppocrv5_latin_dict.txt
        SHA256: b20bd37c168a570f583afbc8cd7925603890efbcdc000a59e22c269d160b5f5a
      eslav_PP-OCRv5_rec_mobile_infer.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/rec/eslav_PP-OCRv5_rec_mobile_infer.onnx
        dict_url: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/paddle/PP-OCRv5/rec/eslav_PP-OCRv5_rec_mobile_infer/ppocrv5_eslav_dict.txt
        SHA256: 08705d6721849b1347d26187f15a5e362c431963a2a62bfff4feac578c489aab
      en_PP-OCRv5_rec_mobile_infer.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/rec/en_PP-OCRv5_rec_mobile_infer.onnx
        dict_url: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/paddle/PP-OCRv5/rec/en_PP-OCRv5_rec_mobile_infer/ppocrv5_en_dict.txt
        SHA256: c3461add59bb4323ecba96a492ab75e06dda42467c9e3d0c18db5d1d21924be8
      th_PP-OCRv5_rec_mobile_infer.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/rec/th_PP-OCRv5_rec_mobile_infer.onnx
        dict_url: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/paddle/PP-OCRv5/rec/th_PP-OCRv5_rec_mobile_infer/ppocrv5_th_dict.txt
        SHA256: de541dd83161c241ff426f7ecfd602a0ba77d686cf3ab9a6c255ea82fd08006e
      el_PP-OCRv5_rec_mobile_infer.onnx:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv5/rec/el_PP-OCRv5_rec_mobile_infer.onnx
        dict_url: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/paddle/PP-OCRv5/rec/el_PP-OCRv5_rec_mobile_infer/ppocrv5_el_dict.txt
        SHA256: b4368bccd557123c702b7549fee6cd1e94b581337d1c9b65310f109131542b7f
      arabic_PP-OCRv4_rec_infer:
        model_dir: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/onnx/PP-OCRv4/rec/arabic_PP-OCRv4_rec_infer.onnx
        dict_url: https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.4.0/paddle/PP-OCRv4/rec/arabic_PP-OCRv4_rec_infer/arabic_dict.txt
        SHA256: 4a9011bef71687bb84288dc86ad2471bd5d37b717ddf672dd156f9e7a5601bac
```

Source: https://github.com/RapidAI/RapidOCR/blob/main/python/rapidocr/default_models.yaml
