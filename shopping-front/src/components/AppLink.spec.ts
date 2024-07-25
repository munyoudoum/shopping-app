import { fireEvent, render, waitFor } from "@testing-library/vue"
import { describe, expect, it } from "vitest"
import { renderOptions } from "src/utils/test/test.utils.ts"
import AppLink from "./AppLink.vue"

describe("# AppLink", () => {
  it("should redirect to another page when click the link", async () => {
    const { getByRole } = render(
      AppLink,
      renderOptions({
        props: { name: "cart" },
      }),
    )
    await fireEvent.click(getByRole("link", { name: "cart" }))

    await waitFor(() =>
      expect(getByRole("link", { name: "cart" })).toHaveClass(
        "router-link-active",
      ),
    )
  })
})
