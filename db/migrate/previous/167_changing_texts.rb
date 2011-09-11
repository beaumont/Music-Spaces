class ChangingTexts < ActiveRecord::Migration
  def self.up
      Relationshiptype.find_by_id(1).update_attributes(
        :explanation => "Use this circle for those followers who have an immediate connection to you. Members of this circle will have access to everything posted for other circles.",
        :explanation_ru => 'Этот круг предназначен для самых близких. Участники этого круга имеют доступ ко всем материалам внешних Кругов.'
      )

      Relationshiptype.find_by_id(2).update_attributes(
        :explanation => "Use this circle as one of the middle circles in your followers structure. If you want to use circles with a subscription fee, this would be a good bet.",
        :explanation_ru => 'Этот круг Вашей аудитории находится посередине. Если Вы планируете использовать платную подписку, этот круг подойдёт для неё как нельзя лучше.'
      )

      Relationshiptype.find_by_id(3).update_attributes(
        :explanation => "Use this circle as one of the middle circles in your followers structure. If you want to use circles with a subscription fee, this would be a good bet.",
        :explanation_ru => 'Этот круг Вашей аудитории находится посередине. Если Вы планируете использовать платную подписку, этот круг подойдёт для неё как нельзя лучше.'
      )

      Relationshiptype.find_by_id(4).update_attributes(
        :explanation => "Use this circle as one of the middle circles in your followers structure. If you want to use circles with a subscription fee, this would be a good bet.",
        :explanation_ru => 'В Вашей структуре кругов этот круг находится посередине. Если Вы планируете использовать платную подписку, Вы можете включить ее для этого круга.'
      )

      Relationshiptype.find_by_id(5).update_attributes(
        :explanation => "Use this circle for people who are willing to express their interest in you and want to simply read your updates on their homepage. This circle is always available for anyone to join.",
        :explanation_ru => 'Этот круг &mdash; для всех, кого заинтересовало Ваше творчество и кому хочется следить за Вашими новостями в своей Ленте друзей. Вступить в этот круг может любой желающий.'
      )
  end

  def self.down
  end
end
