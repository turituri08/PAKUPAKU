# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      site: 'PAKUPAKU',
      title: 'PAKUPAKU',
      reverse: true,
      separator: '|',
      description: '子供が一番成長する時期の大切な離乳食や乳児食作り。困った時は他のママやパパのレシピを参考に、離乳食作りを楽しみましょう',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('logo.jpeg') },
        { href: image_url('apple-touch-icon-180x180.png'), rel: 'apple-touch-icon', sizes: '180x180',
          type: 'image/jpg' }
      ],
      og: {
        site_name: 'PAKUPAKU',
        title: 'PAKUPAKU',
        description: '離乳食や乳児食のレシピ共有SNS',
        type: 'website',
        url: request.original_url,
        image: image_url('og_image.jpeg'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@tsuriyan08'
      }
    }
  end

  def date_format(datetime)
    "#{time_ago_in_words(datetime)}前"
  end
end
