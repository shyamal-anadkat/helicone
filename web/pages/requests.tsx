import { createServerSupabaseClient } from "@supabase/auth-helpers-nextjs";
import { GetServerSidePropsContext } from "next";
import AuthLayout from "../components/shared/layout/authLayout";
import MetaData from "../components/shared/metaData";
import RequestsPage from "../components/templates/requests/requestsPage";
import { getRequests, ResponseAndRequest } from "../services/lib/requests";

interface RequestsProps {
  user: any;
  error: string | null;
  data: ResponseAndRequest[];
  count: number | null;
  page: number;
  from: number;
  to: number;
}

const Requests = (props: RequestsProps) => {
  const { user, data, error, count, page, from, to } = props;

  return (
    <MetaData title="Users">
      <AuthLayout user={user}>
        <RequestsPage
          requests={data}
          error={error}
          count={count}
          page={page}
          from={from}
          to={to}
        />
      </AuthLayout>
    </MetaData>
  );
};

export default Requests;

export const getServerSideProps = async (
  context: GetServerSidePropsContext
) => {
  const supabase = createServerSupabaseClient(context);

  const {
    data: { session },
  } = await supabase.auth.getSession();

  if (!session)
    return {
      redirect: {
        destination: "/login",
        permanent: false,
      },
    };

  const { page, page_size } = context.query;

  let currentPage = parseInt(page as string, 10) || 1;
  const pageSize = parseInt(page_size as string, 10) || 25;

  const { data, error, count, from, to } = await getRequests(
    supabase,
    currentPage,
    pageSize
  );

  return {
    props: {
      initialSession: session,
      user: session.user,
      error: error?.message || null,
      data: (data as ResponseAndRequest[]) || [],
      count: count,
      page: currentPage,
      from: from,
      to: to,
    },
  };
};
