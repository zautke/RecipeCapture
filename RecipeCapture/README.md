# RecipeCapture

RecipeCapture is an iPad app that captures recipe text via OCR and parses it into schema.org compliant JSON structures using a custom ensemble model.

## Features

- OCR integration for capturing recipe text.
- Custom ensemble model combining GPT-NeoX and LayoutLMv3 for robust parsing.
- On-device inference using CoreML for real-time performance.
- User feedback loop for continuous model improvement.

## Setup

### Prerequisites

- Python 3.8+
- PyTorch
- Transformers Library
- CoreML Tools
- Xcode

### Installation

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/yourusername/RecipeCapture.git
    cd RecipeCapture
    ```

2. **Set Up Python Environment:**
    ```bash
    python -m venv env
    source env/bin/activate
    pip install -r requirements.txt
    ```

3. **Prepare Datasets:**
    - Place the datasets in the `data/` directory.
    - Run the merge and augmentation scripts:
        ```bash
        python scripts/merge_datasets.py
        python scripts/augment_data.py
        ```

4. **Fine-Tune Models:**
    ```bash
    python scripts/fine_tune_gpt_neox.py
    python scripts/fine_tune_layoutlmv3.py
    ```

5. **Export to CoreML:**
    ```bash
    python scripts/export_onnx.py
    python scripts/convert_coreml.py
    ```

6. **Run the iOS App:**
    - Open `ios/RecipeCaptureApp.xcodeproj` in Xcode.
    - Add the `.mlmodel` files to the project.
    - Build and run the app on your iPad.

## Contributing

Contributions are welcome! Please open issues and submit pull requests for enhancements and bug fixes.

## License

This project is licensed under the MIT License.