import UIKit

final class DrinkCell: UITableViewCell {
  
  var thumb = UIImageView()
  var title = UILabel()
  var instructions = UILabel()
  
  var onReuse: () -> Void = {}

  override func prepareForReuse() {
    super.prepareForReuse()
    
    onReuse()
    thumb.image = nil
    title.text = ""
    instructions.text = ""
  }
  
  static var reuseIdentifier: String {
    String(describing: Self.self)
  }
  
  //MARK: - Initializers
  
  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(
      style: style,
      reuseIdentifier: reuseIdentifier ?? Self.reuseIdentifier
    )
    
    thumb.translatesAutoresizingMaskIntoConstraints = false
    title.translatesAutoresizingMaskIntoConstraints = false
    title.font = UIFont.preferredFont(forTextStyle: .headline)
    instructions.translatesAutoresizingMaskIntoConstraints = false
    instructions.font = UIFont.preferredFont(forTextStyle: .body)
    instructions.numberOfLines = 4
          
    // Add the UI components
    contentView.addSubview(thumb)
    contentView.addSubview(title)
    contentView.addSubview(instructions)
    
    selectionStyle = .gray
          
    NSLayoutConstraint.activate([
      thumb.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      thumb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      thumb.widthAnchor.constraint(equalToConstant: 50),
      thumb.heightAnchor.constraint(equalToConstant: 50),
      title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      title.leadingAnchor.constraint(equalTo: thumb.trailingAnchor, constant: 8),
      title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      instructions.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
      instructions.leadingAnchor.constraint(equalTo: title.leadingAnchor),
      instructions.trailingAnchor.constraint(equalTo: title.trailingAnchor),
      instructions.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
    ])
  }
  
  func configure(with drink: Drink) {
    
    let placeholderImage = UIImage(systemName: "wineglass")
    thumb.image = placeholderImage
    
    title.text = drink.name
    instructions.text = drink.instructions
    
    thumb.sizeToFit()
    title.sizeToFit()
    instructions.sizeToFit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
