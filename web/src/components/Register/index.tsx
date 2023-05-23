import { createUser } from '../../lib/api';
import { useNavigate } from 'react-router-dom';
import { Button, Form, Input, Layout, Typography } from 'antd';

const { Content } = Layout;
const { Title } = Typography;

type RegisterFormData = {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  passwordConfirmation: string;
};

function RegisterPage() {
  const navigate = useNavigate();

  const handleRegister = async ({
    firstName,
    lastName,
    email,
    password,
    passwordConfirmation,
  }: RegisterFormData) => {
    try {
      await createUser(
        firstName,
        lastName,
        email,
        password,
        passwordConfirmation
      );
      navigate('/');
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <Layout>
      <Content style={{ padding: '50px', maxWidth: '800px', margin: '0 auto' }}>
        <div className="container">
          <Title>Register</Title>
          <Form name="basic" onFinish={handleRegister} autoComplete="on">
            <Form.Item
              label="First Name"
              name="firstName"
              rules={[
                { required: true, message: 'Please input your first name!' },
              ]}
            >
              <Input />
            </Form.Item>

            <Form.Item
              label="Last Name"
              name="lastName"
              rules={[
                { required: true, message: 'Please input your last name!' },
              ]}
            >
              <Input />
            </Form.Item>

            <Form.Item
              label="Email"
              name="email"
              rules={[{ required: true, message: 'Please input your email!' }]}
            >
              <Input />
            </Form.Item>

            <Form.Item
              label="Password"
              name="password"
              rules={[
                { required: true, message: 'Please input your password!' },
              ]}
            >
              <Input.Password />
            </Form.Item>

            <Form.Item
              label="Confirm Password"
              name="passwordConfirmation"
              dependencies={['password']}
              rules={[
                { required: true, message: 'Please confirm your password!' },
                ({ getFieldValue }) => ({
                  validator(_, value) {
                    if (!value || getFieldValue('password') === value) {
                      return Promise.resolve();
                    }
                    return Promise.reject('The two passwords do not match!');
                  },
                }),
              ]}
            >
              <Input.Password />
            </Form.Item>

            <Form.Item wrapperCol={{ offset: 8, span: 16 }}>
              <Button type="primary" htmlType="submit">
                Register
              </Button>
              <Button type="link" onClick={() => navigate('/')}>
                Back
              </Button>
            </Form.Item>
          </Form>
        </div>
      </Content>
    </Layout>
  );
}

export default RegisterPage;