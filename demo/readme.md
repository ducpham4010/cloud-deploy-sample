# terraform plan -out plan.out
Ta có thể chạy câu lệnh plan trước, với thuộc tính -out để xem trước resource, sau đó ta sẽ chạy câu lệnh apply với kết quả của plan trước đó, như sau:
    terraform plan -out plan.out
    terraform apply "plan.out"

# terraform apply -auto-approve
auto approve
# terraform apply -var-file="develop.tfvars"
applly with variable data in develop.tfvars
# terraform destroy -var-file="develop.tfvars"