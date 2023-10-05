import SDWebImage
import UIKit

final class ImageCell: UITableViewCell {
  
  var poster: UIImageView!
  
  var onReuse: () -> Void = {}

  override func prepareForReuse() {
    super.prepareForReuse()
    
    onReuse()
    poster.image = nil
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
    self.poster = poster
          
    // Add the UI components
    contentView.addSubview(poster)
    
    selectionStyle = .gray
          
    NSLayoutConstraint.activate([
      poster.widthAnchor.constraint(equalTo: contentView.widthAnchor),
      poster.heightAnchor.constraint(equalTo: contentView.widthAnchor),
      poster.topAnchor.constraint(equalTo: contentView.topAnchor),
      poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
  
  func configure(with drink: Drink) {
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
