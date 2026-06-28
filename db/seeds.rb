puts "开始创建种子数据..."

users_data = [
  { phone: '13800138001', password: '123456', nickname: '张阿姨', wechat: 'zhangayi_2024', real_name: '张桂兰', experience: '养过3只猫，5年养宠经验' },
  { phone: '13800138002', password: '123456', nickname: '李叔叔', wechat: 'lishushu_love', real_name: '李建国', experience: '救助流浪狗10余年，目前家中有2只狗' },
  { phone: '13800138003', password: '123456', nickname: '王大姐', wechat: 'wangdajie_123', real_name: '王秀芬', experience: '小区救助志愿者，熟悉宠物医疗' },
  { phone: '13800138004', password: '123456', nickname: '小陈同学', wechat: 'xiaochen_pet', real_name: '陈明', experience: '第一次养宠，已做好充足准备' },
  { phone: '13800138005', password: '123456', nickname: '赵小姐', wechat: 'zhaoxiaojie_cute', real_name: '赵雅婷', experience: '养过2只猫，有经验' }
]

users = []
users_data.each do |data|
  user = User.create!(data)
  users << user
  puts "创建用户: #{user.nickname} (#{user.phone})"
end

puts "\n用户创建完成，共 #{users.count} 个用户"

pet_images_data = [
  ['https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400', 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=400'],
  ['https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400', 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=400'],
  ['https://images.unsplash.com/photo-1592194996308-7b43878e84a6?w=400', 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?w=400'],
  ['https://images.unsplash.com/photo-1450778869180-41d0601e046e?w=400'],
  ['https://images.unsplash.com/photo-1573865526739-10659fec78a5?w=400', 'https://images.unsplash.com/photo-1519052537078-e6302a4968d4?w=400'],
  ['https://images.unsplash.com/photo-1561037404-61cd46aa615b?w=400'],
  ['https://images.unsplash.com/photo-1511044568932-338cba0ad803?w=400', 'https://images.unsplash.com/photo-1495360010541-f48722b34f7d?w=400']
]

pets_data = [
  { name: '小黄', species: 'dog', breed: '中华田园犬', size: 'medium', age_months: 12, gender: 'male', source: 'rescued', status: 'listed', description: '非常温顺的小黄，不咬人，喜欢与人亲近。小区流浪3个月，已驱虫。' },
  { name: '咪咪', species: 'cat', breed: '橘猫', size: 'small', age_months: 8, gender: 'female', source: 'rescued', status: 'listed', description: '可爱的小橘猫，特别粘人，会用猫砂盆。' },
  { name: '阿黑', species: 'dog', breed: '边牧串串', size: 'large', age_months: 36, gender: 'male', source: 'abandoned', status: 'listed', description: '原主人搬家弃养，非常聪明，会坐下握手等指令。' },
  { name: '花花', species: 'cat', breed: '三花猫', size: 'small', age_months: 6, gender: 'female', source: 'rescued', status: 'listed', description: '在小区花园捡到的，性格活泼，喜欢玩耍。' },
  { name: '豆豆', species: 'dog', breed: '泰迪', size: 'small', age_months: 24, gender: 'male', source: 'abandoned', status: 'unlisted', description: '主人怀孕弃养，不掉毛，适合公寓饲养。' },
  { name: '雪球', species: 'cat', breed: '白猫', size: 'small', age_months: 4, gender: 'unknown', source: 'rescued', status: 'listed', description: '白色长毛小猫，蓝眼睛，非常漂亮。' },
  { name: '旺财', species: 'dog', breed: '金毛串串', size: 'large', age_months: 48, gender: 'male', source: 'rescued', status: 'adopted', description: '很乖的大狗狗，已被领养。' }
]

pets = []
pets_data.each_with_index do |pet_data, index|
  pet = users[index % 3].pets.create!(pet_data)
  pet_images_data[index]&.each do |img_url|
    pet.pet_images.create!(url: img_url)
  end
  pets << pet
  puts "创建宠物: #{pet.name} (#{pet.species} - #{pet.status})"
end

puts "\n宠物创建完成，共 #{pets.count} 只宠物"

applications_data = [
  { applicant_name: '小陈同学', applicant_phone: '13800138004', applicant_wechat: 'xiaochen_pet', experience: '第一次养宠，已做好充足准备', reason: '想给家人一个惊喜，从小就喜欢小动物', status: 'pending', pet_index: 0, applicant_index: 3 },
  { applicant_name: '赵小姐', applicant_phone: '13800138005', applicant_wechat: 'zhaoxiaojie_cute', experience: '养过2只猫，有经验', reason: '家里的猫去年走了，想再领养一只陪伴', status: 'approved', pet_index: 6, applicant_index: 4 },
  { applicant_name: '小陈同学', applicant_phone: '13800138004', applicant_wechat: 'xiaochen_pet', experience: '第一次养宠，已做好充足准备', reason: '女朋友特别喜欢橘猫', status: 'pending', pet_index: 1, applicant_index: 3 },
  { applicant_name: '赵小姐', applicant_phone: '13800138005', applicant_wechat: 'zhaoxiaojie_cute', experience: '养过2只猫，有经验', reason: '想给家里的猫找个伴', status: 'rejected', pet_index: 2, applicant_index: 4 }
]

applications = []
applications_data.each do |app_data|
  application = AdoptionApplication.create!(
    applicant_name: app_data[:applicant_name],
    applicant_phone: app_data[:applicant_phone],
    applicant_wechat: app_data[:applicant_wechat],
    experience: app_data[:experience],
    reason: app_data[:reason],
    status: app_data[:status],
    pet: pets[app_data[:pet_index]],
    applicant: users[app_data[:applicant_index]]
  )
  applications << application
  puts "创建领养申请: #{application.applicant_name} 申请 #{application.pet.name} (#{application.status})"
end

puts "\n领养申请创建完成，共 #{applications.count} 份申请"

approved_app = applications.find { |a| a.status == 'approved' }
if approved_app
  Message.create!(
    title: '领养申请已通过',
    content: "您对宠物「#{approved_app.pet.name}」的领养申请已通过！救助人微信号：#{approved_app.pet.user.wechat}，请尽快联系。",
    sender: approved_app.pet.user,
    receiver: approved_app.applicant,
    pet: approved_app.pet,
    application: approved_app
  )
  Message.create!(
    title: '您的宠物有新的领养人',
    content: "您登记的宠物「#{approved_app.pet.name}」的领养申请已通过！申请人：#{approved_app.applicant_name}，联系电话：#{approved_app.applicant_phone}，微信号：#{approved_app.applicant_wechat}。",
    sender: approved_app.applicant,
    receiver: approved_app.pet.user,
    pet: approved_app.pet,
    application: approved_app
  )
  puts "为已通过的申请创建了双向通知消息"
end

puts "\n=== 种子数据创建完成！==="
puts "测试账号："
users.each do |u|
  puts "  #{u.nickname}: #{u.phone} / 123456"
end
