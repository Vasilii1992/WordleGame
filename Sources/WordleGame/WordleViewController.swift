
import UIKit

public final class WordleViewController: UIViewController {
    
    public let answers = [
    "after", "later", "bloke", "there", "ultra"
    ]
    public var answer = ""
    private var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    
    public let keyboardVC = KeyboardViewController()
    public let boardVC = BoardViewController()
    
    public var backButtonImage: UIImage?
    public var backButtonTintColor: UIColor?

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        answer = answers.randomElement() ?? "after"
        addChildren()
        setupCustomButton()
    }
    
    private func setupCustomButton() {
        let backButton = UIBarButtonItem(image: backButtonImage ?? UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backBarButtonItemTapped))
        backButton.tintColor = backButtonTintColor ?? .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc public func backBarButtonItemTapped() {
           navigationController?.popViewController(animated: true)
       }
    
    private func setupViews() {
        title = "Wordle"
        view.backgroundColor = .systemGray6
    }

    private func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        boardVC.datasource = self
        view.addSubview(boardVC.view)
        
        addConstraints()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension WordleViewController: KeyboardViewControllerDelegate {
   public func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        var stop = false
        
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                  guesses[i][j] = letter
                    stop = true
                    break
                    
                }
            }
            if stop {
                break
            }
        }
        boardVC.reloadData()
        checkCurrentGuess()
    }
    
    private func checkCurrentGuess() {
        for row in guesses {
            let count = row.compactMap { $0 }.count
            if count == 5 {
                let guessWord = String(row.compactMap { $0 })
                if guessWord.lowercased() == answer.lowercased() {
                    resultAlert(title: "Вы угадали слово!\n\(guessWord.uppercased())")
                }
            }
        }
    }
    
    private func resetGame() {
        guesses = Array(repeating: Array(repeating: nil, count: 5), count: 6)
        answer = answers.randomElement() ?? "after"
        boardVC.reloadData()
    }
    
    private func resultAlert(title: String) {
        
        let ac = UIAlertController(title: title,
                                   message: nil,
                                   preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { [weak self] _ in
            self?.resetGame()
        }))
        present(ac, animated: true)
    }
}

extension WordleViewController: BoardViewControllerDataSource {
  public var currentGuesses: [[Character?]] {
        return guesses
    }
    
   public func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        
        let count = guesses[rowIndex].compactMap { $0 }.count
        guard count == 5 else {
            return nil
        }
        
        let indexedAnswer = Array(answer)

        
        guard let letter = guesses[indexPath.section][indexPath.row], indexedAnswer.contains(letter) else { return nil }
        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        return .systemOrange
    }
}
