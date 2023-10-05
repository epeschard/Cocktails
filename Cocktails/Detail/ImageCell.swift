import SDWebImage
import UIKit

final class ImageCell: UITableViewCell {
  
  var poster: UIImageView!
  var attribution = UILabel()
  var creativeCommons = UIImageView()
  
  var onReuse: () -> Void = {}

  override func prepareForReuse() {
    super.prepareForReuse()
    
    onReuse()
    poster.image = nil
    attribution.text = ""
    creativeCommons.image = nil
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
  }
   
  func setupViews() {
    let poster = UIImageView()
    poster.translatesAutoresizingMaskIntoConstraints = false
    poster.contentMode = .scaleAspectFit
    attribution.translatesAutoresizingMaskIntoConstraints = false
    attribution.font = UIFont.preferredFont(forTextStyle: .body)
    creativeCommons.translatesAutoresizingMaskIntoConstraints = false
    self.poster = poster
          
    // Add the UI components
    contentView.addSubview(poster)
    contentView.addSubview(attribution)
    contentView.addSubview(creativeCommons)
    
    selectionStyle = .gray
          
    NSLayoutConstraint.activate([
      poster.widthAnchor.constraint(equalTo: contentView.widthAnchor),
      poster.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0),
      poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      poster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      poster.topAnchor.constraint(equalTo: contentView.topAnchor),
      poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      attribution.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
      attribution.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
      attribution.leadingAnchor.constraint(greaterThanOrEqualTo: creativeCommons.trailingAnchor),
      attribution.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
      attribution.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      creativeCommons.heightAnchor.constraint(equalToConstant: 25),
      creativeCommons.widthAnchor.constraint(equalToConstant: 25),
      creativeCommons.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      creativeCommons.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
    ])
  }
  
  func configure(with drink: Drink) {
    attribution.text = drink.strImageAttribution ?? ""
    creativeCommons.image = UIImage(named: "cc-sticker")
    creativeCommons.isHidden = drink.strCreativeCommonsConfirmed == nil
    
    let placeholderImage = UIImage(systemName: "wineglass")
    guard
      let string = drink.thumbnail,
      let thumbnailURL = URL(string: string)
    else {
      poster.image = placeholderImage
      poster.sizeToFit()
      return
    }
    poster.sd_setImage(
      with: thumbnailURL,
      placeholderImage: placeholderImage
    )
    poster.sizeToFit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
